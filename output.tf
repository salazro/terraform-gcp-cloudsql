output "cloud-sql-connection-name" {
  value = google_sql_database_instance.cloudsql.connection_name
}

output "cloud-sql-instance-name" {
  value = "${var.db_instance}-${random_string.db_instance_suffix.result}"
}