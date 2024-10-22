variable a1 {
  type =string
  #Definition: A single line of text(sequence of characters)
}

variable a2{
  type = number
  #Definition:Any numeric value.
}

variable a3{
  type = bool
  #Definition:Boolean values, either true or false(binary value)
}

variable a4{
  type = list 
  #Definition:list of values with a single data type.Uses square braces.
}

variable a5{
  type=map
  #Definition:A key-value pair where all the values are of the same type(dictionary where keys map to specific values),Uses flower braces.
}

variable a6{
  type=tuple([string, number,list(any)])
  #Definition:Like a list, but each element can be a different data type.
}


output a1 {
value = var.a1

}

output a2 {
value = var.a2
}

output a3 {
value = var.a3
}

output a4{
value = var.a4[2]
}

output a5{
  value = var.a5.name
}

output a6 {
  value = var.a6[2][1]
}

resource "local_file" "r1"{
    filename = var.a1
    content = var.a4
}

resource "local_file" "r2"{
    filename = var.a5
    content = var.a2
}
