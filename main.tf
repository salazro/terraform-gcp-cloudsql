
data "google_compute_network" "vpc_network" {
  name = var.vpc_network
}
resource "random_string" "db_instance_suffix" {
  length  = 4
  special = false
  upper   = false
}


resource "google_sql_database_instance" "cloudsql" {

  # Instance info
  name             = "${var.db_instance}-${random_string.db_instance_suffix.result}"
  region           = var.region
  database_version = var.db_version

  settings {

    # Region and zonal availability
    availability_type = var.db_availability_type
    location_preference {
      zone = var.db_location_preference
    }

    # Machine Type
    tier = var.db_machine_type

    # Storage
    disk_size = var.db_default_disk_size

    # Connections
    ip_configuration {
      ipv4_enabled    = false
      private_network = data.google_compute_network.vpc_network.id
    }

    # Backups
    backup_configuration {
      binary_log_enabled = true
      enabled            = true
      start_time         = "06:00"
    }
  }
  depends_on = [
    google_service_networking_connection.private-vpc-connection
  ]
}

data "google_secret_manager_secret_version" "db_admin_user_password" {
  secret = var.db_admin_user_password_in_secret_manager
}

resource "google_sql_database" "database" {
  for_each = toset(var.db_list)
  name     = each.value
  instance = google_sql_database_instance.cloudsql.name
}

resource "google_sql_user" "user" {
  for_each = toset(var.db_list)
  name     = var.db_user
  instance = each.value
  password = data.google_secret_manager_secret_version.db_admin_user_password.secret_data
}



#Private Connection Configuration
#We need to configure private services access to allocate an IP address range 
#and create a private service connection. This will allow resources in the Web subnet 
#to connect to the Cloud SQL instance

resource "google_compute_global_address" "private-ip-peering" {
  name          = "${var.vpc_network}-global_address-vpc-peering"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = data.google_compute_network.vpc_network.id #TODO: this is the network where the gke cluster will be paired
  
  depends_on = [google_compute_network.vpc_network]
}

resource "google_service_networking_connection" "private-vpc-connection" {
  network = data.google_compute_network.vpc_network.id #TODO: this is the network where the gke cluster is deployed
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.private-ip-peering.name
  ]
  
  depends_on = [google_compute_network.vpc_network]
}


