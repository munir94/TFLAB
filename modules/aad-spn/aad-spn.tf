# data "azuread_client_config" "current" {}

# resource "azuread_application" "aad-app-spn01" {
#   display_name = var.spn-name
#   sign_in_audience = "AzureADMultipleOrgs"
#   owners       = [data.azuread_client_config.current.object_id]
# }

# # resource "azuread_service_principal" "aad-spn" {
# #   application_id               = azuread_application.aad-app-spn01.application_id
# #   app_role_assignment_required = false
# #   owners                       = [data.azuread_client_config.current.object_id]
# # }


# resource "time_rotating" "secret-rotate" {
#   rotation_months = 24
# }

# # resource "azuread_service_principal_password" "example" {
# #   service_principal_id = azuread_service_principal.aad-spn.object_id
# #   rotate_when_changed = {
# #     rotation = time_rotating.example.id
# #   }
# # }
#  #https://stackoverflow.com/questions/69615473/how-to-create-a-client-secret-using-terraform
# resource "azuread_application_password" "password" {
#   display_name = var.secret-name
#  # application_object_id = azuread_application.example.object_id
#   application_object_id = azuread_application.aad-app-spn01.object_id
#  rotate_when_changed = {
#     rotation = time_rotating.secret-rotate.id
#   }
# }

resource "azuread_application" "main" {
 display_name = var.spn-name
  
}

resource "azuread_service_principal" "main" {
  application_id = azuread_application.main.application_id
}

resource "random_password" "main" {
  length  = 32
  special = false
}

resource "time_rotating" "secret-rotate" {
  rotation_months = 24
}
resource "azuread_application_password" "main" {
  display_name = var.secret-name
  application_object_id  = azuread_application.main.id  
  #value                  = random_password.main.result
  rotate_when_changed = {
    rotation = time_rotating.secret-rotate.id
  }
}