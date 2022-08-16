resource "azurerm_subscription_cost_management_export" "cost-export" {
  name                         = var.costexport-name
  subscription_id              = "/subscriptions/${var.sub-id}"
  recurrence_type              = "Daily"
#   recurrence_period_start_date = formatdate("YYYY-MM-DD'T'hh:mm:ssZ",timestamp())
#   recurrence_period_end_date   = timeadd(recurrence_period_start_date,"1y")
  recurrence_period_start_date = "2022-08-16T00:00:00Z"
  recurrence_period_end_date   = "2023-09-18T00:00:00Z"
  export_data_storage_location {
    container_id     = var.sacontainer-id 
    root_folder_path = var.sapath
  }
  export_data_options {
    type       = "Usage"
    time_frame = "MonthToDate"
  }
}
output "endate" {
  value = "Endate for Cost export is ${azurerm_subscription_cost_management_export.cost-export.recurrence_period_end_date}"
}