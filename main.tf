provider "local"{}
# Start a container
resource "docker_container" "jboss7" {
  image = "${docker_image.jboss7.latest}"
  must_run = true
  name  = "jboss7"
     ports {
        internal = 9990
        external = 9990
        }
}

# Find the latest precise image.
resource "docker_image" "jboss7" {
  name = "daggerok/jboss-eap-7.2"
}