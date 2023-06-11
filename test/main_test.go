package test

import (
	"context"
	"fmt"
	"io/fs"
	"log"
	"os"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/iam"
	test_structure "github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

const localBackend = `
terraform {
	backend "local" {}
}
`

func setupTest() (string, error) {
	terraformTempDir, errCopying := test_structure.CopyTerragruntFolderToTemp("../", "terratest-")
	if errCopying != nil {
		return "", errCopying
	}

	backendFilePath := fmt.Sprintf("%s/%s", terraformTempDir, "backend.tf")
	errRemoving := os.Remove(backendFilePath)
	if errRemoving != nil {
		return "", errRemoving
	}

	errWritingFile := os.WriteFile(backendFilePath, []byte(localBackend), os.ModeAppend)
	if errWritingFile != nil {
		return "", errWritingFile
	}
	os.Chmod(backendFilePath, fs.FileMode(0777))
	return terraformTempDir, nil
}

const tfWorkspaceEnvVarName = "TF_WORKSPACE"
const targetWorkspace = "test"
const testRunIDOutputKey = "test_run_id"

func TestTerraformCodeInfrastructureInitialCredentials(t *testing.T) {
	//Region := "ap-southeast-1"
	terraformTempDir, errSettingUpTest := setupTest()
	if errSettingUpTest != nil {
		t.Fatalf("Error setting up test :%v", errSettingUpTest)
	}
	defer os.RemoveAll(terraformTempDir)
	log.Printf("Temp folder: %s", terraformTempDir)
	terraformInitOptions := &terraform.Options{
		TerraformDir: terraformTempDir,
		VarFiles:     []string{"test/terratest.tfvars"},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "ap-southeast-1",
			//"TF_LOG":             "TRACE",
		},
		Reconfigure: true,
	}

	defer destroy(t, terraformTempDir)
	terraform.Init(t, terraformInitOptions)
	terraform.WorkspaceSelectOrNew(t, terraformInitOptions, targetWorkspace)
	terraformValidateOptions := &terraform.Options{
		TerraformDir: terraformTempDir,
		EnvVars: map[string]string{
			tfWorkspaceEnvVarName: targetWorkspace,
		},
	}
	terraform.Validate(t, terraformValidateOptions)
	plan, errApplyingIdempotent := terraform.ApplyAndIdempotentE(t, terraformInitOptions)
	if errApplyingIdempotent != nil {
		t.Logf("Error applying plan: %v", errApplyingIdempotent)
		t.Fail()
	} else {
		t.Log(fmt.Sprintf("Plan worked: %s", plan))
	}
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatal(err)
	}

	testRunID := terraform.Output(t, terraformInitOptions, testRunIDOutputKey)

	// Create an Amazon S3 service client
	client := iam.NewFromConfig(cfg)
	t.Run("Test #1: Create user group and polcies", func(t *testing.T) {
		a := assert.New(t)
		var err error
		testUser := fmt.Sprintf("test-user-%s", testRunID)
		testPolicy := fmt.Sprintf("test-policy-%s", testRunID)
		testGroup := fmt.Sprintf("test-group-%s", testRunID)

		testUserV, err := client.GetUser(context.TODO(), &iam.GetUserInput{
			UserName: &testUser,
		})
		a.NoError(err)

		a.Equal(testUser, *testUserV.User.UserName)
		a.Equal("createdBy", *testUserV.User.Tags[0].Key)
		a.Equal("createdBy aws-iam/user", *testUserV.User.Tags[0].Value)
		a.Equal("/", *testUserV.User.Path)

		testGroupV, err := client.GetGroup(context.TODO(), &iam.GetGroupInput{
			GroupName: &testGroup,
		})
		a.NoError(err)

		a.Equal(testGroup, *testGroupV.Group.GroupName)
		a.Equal("/", *testGroupV.Group.Path)
		a.Equal(testUser, *testGroupV.Users[0].UserName)

		testGroupPolicies, err := client.ListAttachedGroupPolicies(context.TODO(), &iam.ListAttachedGroupPoliciesInput{
			GroupName: &testGroup,
		})

		a.NotNil(testGroupPolicies)
		a.NoError(err)

		a.Equal(testPolicy, *testGroupPolicies.AttachedPolicies[0].PolicyName)
	})

	t.Run("Test #2: Create user group and polcies", func(t *testing.T) {
		a := assert.New(t)
		var err error
		testUser := fmt.Sprintf("test-user2-%s", testRunID)
		testPolicy := fmt.Sprintf("test-policy2-%s", testRunID)
		testGroup := fmt.Sprintf("test-group2-%s", testRunID)
		testRole := fmt.Sprintf("dummy-role-%s", testRunID)

		testUserV, err := client.GetUser(context.TODO(), &iam.GetUserInput{
			UserName: &testUser,
		})
		a.NoError(err)

		a.Equal(testUser, *testUserV.User.UserName)
		a.Equal("createdBy", *testUserV.User.Tags[0].Key)
		a.Equal("createdBy aws-iam/user", *testUserV.User.Tags[0].Value)
		a.Equal("/test2/", *testUserV.User.Path)

		testGroupV, err := client.GetGroup(context.TODO(), &iam.GetGroupInput{
			GroupName: &testGroup,
		})
		a.NoError(err)

		a.Equal(testGroup, *testGroupV.Group.GroupName)
		a.Equal("/test2/", *testGroupV.Group.Path)
		a.Equal(testUser, *testGroupV.Users[0].UserName)

		testGroupPolicies, err := client.ListAttachedGroupPolicies(context.TODO(), &iam.ListAttachedGroupPoliciesInput{
			GroupName: &testGroup,
		})

		a.NotNil(testGroupPolicies)
		a.NoError(err)

		a.Equal(testPolicy, *testGroupPolicies.AttachedPolicies[0].PolicyName)

		dummyRoleV, err := client.GetRole(context.TODO(), &iam.GetRoleInput{
			RoleName: &testRole,
		})

		a.NoError(err)

		a.Equal(testRole, *dummyRoleV.Role.RoleName)

	})
}
