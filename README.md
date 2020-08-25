# terraform-demo
This is a small terraform demo repo.

# What is Terraform?
Terraform is an Open Source project of Hashicorp. It is an executable that reads HCL (Hashicorp Configuration Language) in files to give instructions to various infrastructure Providers (e.g., AWS), which generally use cloud provider APIs to cause actual infrastructure to be queried and provisioned as specified -- i.e., Infrastructure as Code (IaC). The Terraform executable is written in Go, so various pieces of the broader Terraform ecosystem use that language.

Hashicorp provides several classes of Terraform as a Service -- the biggest differences are a UI and the fact that Hashicorp handles the CI/CD infrastructure on which terraform runs. My opinion is that most dev orgs for whom CI/CD is an area of expertise should run Terraform themselves.

Sometimes orgs run Terraform in a wrapper such as Terragrunt -- this was especially common in the past because many desirable features had not been present in early versions of Terraform.

The author of Terragrunt, Yevgeniy Brikman, wrote what I would consider the foundational work on Terraform, which any serious practitioner should check out: https://blog.gruntwork.io/a-comprehensive-guide-to-terraform-b3d32832baca

# Basic Building-Block Concepts

## State
Terraform stores the state of deployed infrastructure in a file (you `init` to create a new state). Any time you execute a Terraform command (e.g., `plan`, `apply`, or `destroy`) Terraform will refresh against Provider APIs to ensure it knows (**to the best of its ability**) what the actual deployed infrastructure is, and it will compute a diff against the code in the terraform directory. The state will be stored in a `local` file by default, which is fine for one person... but gemerally not for organizations. `remote` state can be stored in s3 or similar, and can also lock (only one operation occurring at any time to avoid conflicts) using dynamoDB (or similar).

## Resources
For each infrastructure API (e.g., AWS, GCP, K8S), there is a Provider which is a plugin that translates between Terraform syntax and a cloud-provider-specific set of resources and APIs. Thus, the most basic building-block of actually specifying infrastructure in Terraform code is the `resource`.

## Modules
As of Terraform 0.13, `modules` can be thought of pretty closely to custom-defined resources. Unlike a Provider, which is implementing a lower-level set of API calls and exposing a resource API, a module is being built with existing `resources` and other blocks of HCL in normal Terraform code. However, the usage is (now) pretty similar, and the idea is that you can create logical compositions of resources and other modules -- and then once defined, you can instantiate these with different arguments in a predictable way.

A module is any set of valid Terraform files in a directory specifying some number of the following:

  * **Resources and Other Blocks** - Often in well-named files and/or a file called `main.tf`, any number of resource and other HCL blocks will be included in the module.
  * **Variables** - By convention, variables are often separated out into their own file (`vars.tf`). `variable` is simply a type of Terraform code block that is used to indicate parameterization of a module -- you have to refer to the variable block where a value is needed in the module, and when the module is invoked all variables must have a value.
  * **Outputs** - By convention, outputs are often separated out into their own file (`outputs.tf`). `output` is simply a type of Terraform code block that is used to indicate values that will be available as results of a module. Values that are available within a module are encapsulated in the module, so any values you want to make available to module callers must utilize the *output* block.

Often there is a distinction drawn between two types of module:

  * **Child** - `child` modules are only intended to be used as building blocks and lack (by design) certain configuration elements.
  * **Root** - `root` modules are actually applied to a live environment and reflected in a state file, and must include all necessary configuration elements (such as `terraform` and `backend` config blocks).

A child module is specified when it is invoked via a `source` argument. A common method is by relative path, but modules can also be pulled from public or private module repositories, from source code repositories (e.g., via git), or from cloud file stores (e.g., s3).

## Variable Input
At some point the literal values of parameters must be supplied. They can be supplied in many ways: on the command line (`-var="key=value"`), from environment variables (`TF_VAR_<key>`), via file reference (`-var-file=<name.tfvars>`), and/or via automatic inclusion of files (by naming convention `terraform.tfvars` or `<name>.auto.tfvars`, from the execution directory). Handling variables is one of the most compelling remaining reasons to use Terraform wrappers. Sensitive values may need to be passed into variables, and caution needs to be utilized to prevent those showing up in source code (files), logs/history, etc. Your strategy for this should be part of a well-considered secrets management regime.

# Best Practices
Terraform usage can impact a project's ability to continuously deliver reliable code improvements.

## Parallel, Hierarchical Environments
When environment and/or major environment components are parameterized and output as modules, they can be instantiated reliably in a parallel, heirachical promotion process, ensuring that lower level environments have the same nuances and quirks as upper level/production environments. Parameterized module usage can lock this in and expose the specific distinctions between *versions* of the environment as a DevOps organization builds a cloud product (which includes infrastructure as part of the code base) and *parameters* of each environment.

## Immutable, Versioned Modules
When modules are sourced from the cloud, (e.g., git), they can reference point-in-time versions. A module *source* argument that uses git can reference a tag or commit, locking in the specific version of the dependency used, which means that dependencies are immutable and versioned -- again, ensuring reliable deploys and enabling a whole team to work on infrastructure as part of the code without unpredictable impacts.

## Version-Locked Executable Dependencies
When modules and especially the live module version-lock Terraform and the Provider executables, the project is insulated from changes from Hashicorp and the cloud provider. Note that Terraform is on major version **0**. Breaking changes have frequently hit major organizations that did not do this.

## Root Structure
The structure of the root (live) Terraform directory can have major impacts on legibility and function. Ideally, it should be a 1:1 representation of actual deployed infrastructure in the cloud. It is very helpful if variables can be kept relatively DRY (Don't Repeat Yourself) and follow a natural structure of real environment componentization/heirarchies... but this may only be possible with wrappers. It is important to consider state file dependency as well as breaking code into legible and logical chunks -- we want to follow good coding practices and also limit the blast area of mistakes. The general topic of Terraform structure is well-debated, but (and) impactful.
