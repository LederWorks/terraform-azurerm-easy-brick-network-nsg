locals {
  ################################ Tags
  tags = merge(
    var.tags,
    {
      creation_mode                                  = "terraform"
      terraform-provider-easy-brick-category-purpose = "vX.X.X"
    }
  )

}