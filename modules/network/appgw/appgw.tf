

resource "azurerm_resource_group" "ag-rg" {
  name     = var.agrg
  location = var.loc
}

resource "azurerm_public_ip" "agip" {
  name                = var.agip
  resource_group_name = azurerm_resource_group.ag-rg.name
  location            = azurerm_resource_group.ag-rg.location
  allocation_method   = "Static"
  sku = "Standard"
  sku_tier = "Regional"
  availability_zone = "Zone-Redundant"
}

locals {
  test_backend_address_pool_name = "dummy"
  test_fqdn = "dummy"
}

resource "azurerm_application_gateway" "agw" {
  name                = "${var.agname}-GW01"
  resource_group_name = azurerm_resource_group.ag-rg.name
  location            = azurerm_resource_group.ag-rg.location

  sku {
    name = var.ag_sku
    tier = var.ag_tier
  }

  autoscale_configuration {
    min_capacity = var.ag_min
    max_capacity = var.ag_max
  }
  
  ## SSL CERT 
  
  # ssl_certificate {
  #   name     = var.certificate_name
  #   data     = filebase64(var.certificate_path)
  #   password = var.certificate_pwd
  # }

  gateway_ip_configuration {
    name      = var.agsnetname
    subnet_id = var.agsnetid
  }

  frontend_port {
    name = "${var.agname}-feport"
    port = 80
  }

  frontend_port {
    name = "https_port"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "${azurerm_public_ip.agip.name}-feip"
    public_ip_address_id = azurerm_public_ip.agip.id
  }

  
  backend_address_pool {
   name = "${var.agname}-beap"
   fqdns = [
        "cafdemo.appserviceenvironment.net"
      ]
}

  backend_http_settings {
    name                  = "${var.agname}-be-htst"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "${var.agname}-httplstn"
    frontend_ip_configuration_name = "${azurerm_public_ip.agip.name}-feip"
    frontend_port_name             = "${var.agname}-feport"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${var.agname}-rqrt"
    rule_type                  = "Basic"
    http_listener_name         = "${var.agname}-httplstn"
    backend_address_pool_name  = "${var.agname}-beap"
    backend_http_settings_name = "${var.agname}-be-htst"
    # http_listener_name         = "${var.agname}-httplstn"
    # backend_address_pool_name  = "${var.agname}-beap"
    # backend_http_settings_name = "${var.agname}-be-htst"
  }
  lifecycle {
  ignore_changes = [
    backend_address_pool,
    backend_http_settings,
    frontend_port,
    http_listener,
    probe,
    redirect_configuration,
    request_routing_rule,
    ssl_certificate,
    tags,
    url_path_map,
  ]
}
 
}


