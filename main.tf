resource "random_string" "db_name_suffix" {
  length  = 4
  special = false
  upper   = false
}


resource "google_sql_database_instance" "cloudsql" {

  # Instance info
  name             = "${var.database_name}-private-${random_string.db_name_suffix.result}"
  region           = var.region
  database_version = var.database_version

  settings {

    # Region and zonal availability
    availability_type = var.database_availability_type
    location_preference {
      zone = var.database_location_preference
    }

    # Machine Type
    tier              = var.database_machine_type

    # Storage
    disk_size         = var.database_default_disk_size

    # Connections
    ip_configuration {
      ipv4_enabled        = false
      private_network     = google_compute_network.custom.id
    }

    # Backups
    backup_configuration {
      binary_log_enabled = true
      enabled = true
      start_time = "06:00"
    }
  }
  depends_on = [
    google_service_networking_connection.private-vpc-connection
  ]
}
