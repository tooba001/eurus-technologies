resource "aws_appstream_stack" "test_stack" {
  name        = "tooba-stack"
  description = "AppStream stack example"
  display_name = "tooba AppStream Stack"

  storage_connectors {
    connector_type = "HOMEFOLDERS"  # Optionally, add S3 or other connectors
  }

  application_settings {
    enabled = true
    settings_group = "example-settings"
  }

  user_settings {
    action = "CLIPBOARD_COPY_FROM_LOCAL_DEVICE"
    permission = "ENABLED"
  }

  user_settings {
    action = "CLIPBOARD_COPY_TO_LOCAL_DEVICE"
    permission = "ENABLED"
  }
}


resource "aws_appstream_fleet_stack_association" "example" {

  fleet_name = aws_appstream_fleet.test_fleet.name
  stack_name = aws_appstream_stack.test_stack.name
  
  depends_on = [
   aws_appstream_fleet.test_fleet,
   aws_appstream_stack.test_stack
  ]

}


