resource "aws_appstream_fleet" "test_fleet" {
  name = "test-fleet"

  compute_capacity {
    desired_instances = 1
  }

  description                        = "test fleet"
  idle_disconnect_timeout_in_seconds = 60
  display_name                       = "test-fleet"
  enable_default_internet_access     = false
  fleet_type                         = "ON_DEMAND"
  image_name                         = "slack-imagebuilder"
  instance_type                      = "stream.standard.large"
  max_user_duration_in_seconds       = 1200

  vpc_config {
    subnet_ids = [ "subnet-067867484a74142ef"]
  }

  tags = {
    TagName = "test-fleet"
  }
}