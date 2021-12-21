
module "cloudsql" {
    source = "git@github.com:MavenCode/terraform-gcp-cloudsql.git"

    region = var.region
    db_location_preference = var.db_location_preference
    db_machine_type = var.db_machine_type
    db_version = var.db_version
    db_default_disk_size = var.db_default_disk_size
    db_availability_type = var.db_availability_type
    db_admin_user_password_in_secret_manager = var.db_admin_user_password_in_secret_manager
    db_list = var.db_list
    db_instance = var.db_instance
    db_user = var.db_user
    network_name = var.network_name
}