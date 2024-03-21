// Module Test
package main

import (
	"os"
	"testing"

	"github.com/LederWorks/golang-easy-terratest/rgrp"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraform(t *testing.T) {
	t.Parallel()

	// Retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: ".",
		Upgrade:      true,
		BackendConfig: map[string]interface{}{
			"tenant_id":            os.Getenv("ARM_TENANT_ID"),
			"subscription_id":      os.Getenv("ARM_SUBSCRIPTION_ID"),
			"resource_group_name":  "rgrp-pde3-it-terratest", // os.Getenv("AZURERM_BACKEND_RGRP"),
			"storage_account_name": "saccpde3itterratest001", // os.Getenv("AZURERM_BACKEND_SACC"),
			"container_name":       "terratest-azurerm",      // os.Getenv("AZURERM_BACKEND_CONTAINER"),
			"key":                  "easy-brick-network-nsg.default.tfstate",
			"snapshot":             "true",
			"use_azuread_auth":     "true",
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created.
	defer terraform.Destroy(t, terraformOptions)

	// Run tf version
	terraform.RunTerraformCommand(t, terraformOptions, "version")

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	//tenantID := terraform.Output(t, terraformOptions, "tenant_id")
	subscriptionID := terraform.Output(t, terraformOptions, "subscription_id")
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
	//clientID := terraform.Output(t, terraformOptions, "client_id")

	// Run test for resource group
	rgrp.TestResourceGroupExists(t, terraformOptions, subscriptionID, resourceGroupName)

	// Run test for something else
	//testSomethingElse(t, terraformOptions, subscriptionID)
}
