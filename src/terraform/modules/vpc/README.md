## Required Inputs

The following input variables are required:

### availability\_zones

Description: the list of availability\_zones for the subnets

Type: `list(string)`

### deploy\_nat

Description: n/a

Type: `bool`

### project

Description: define the class id from devops academy

Type: `string`

### vpc\_cidr

Description: define the vpc cidr\_block

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### common\_tags

Description: define tags which will be applied for every resource created

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### private\_subnets

Description: list of private\_subnets created

### public\_subnets

Description: list of public\_subnets created

### vpc\_id

Description: n/a

