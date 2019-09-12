variable "name" {
  description = "The name of the lambda to create, which also defines (i) the archive name (.zip), (ii) the file name, and (iii) the function name"
  default     = "lambda"
}

variable "runtime" {
  description = "The runtime of the lambda to create"
  default     = "nodejs6.10"
}

variable "handler" {
  description = "The handler name of the lambda (a function defined in your lambda)"
  default     = "handler"
}

variable "zip_file_path" {
  description = "path of the zip file"
  default     = "./"
}
