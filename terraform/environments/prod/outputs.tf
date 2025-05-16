output "load_balancer_url" {
  description = "Public DNS name of the Application Load Balancer"
  value       = "http://${module.alb.alb_dns_name}"
}