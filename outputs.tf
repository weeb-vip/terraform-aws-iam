output "test_run_id" {
  description = "ID of this test run. Generated for every test run."
  value       = random_string.test_run_id.result
}
