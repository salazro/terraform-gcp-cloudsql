variable "region" {
  type = string
  default = "us-central1"
}

variable "db_location_preference" {
  type = string
  default = "us-central1-a"
}

variable "db_instance" {
  type = string
}


variable "db_machine_type" {
  type = string
  default = "db-n1-standard-2"
}

variable "db_version" {
  type = string
  default = "POSTGRES_12"
}

variable "db_default_disk_size" {
  type = string
  default = "100"
}

variable "db_availability_type" {
  type = string
  default = "REGIONAL"
}

variable "db_admin_user_password_in_secret_manager" {
  type = string
}

variable "db_list" {
  type = list
  description = "list of databases that should be create in an instance"
}

variable "db_user" {
  type = string
}


variable "network" {
  type = string
  description = "vpc network where database will be deployed"
}