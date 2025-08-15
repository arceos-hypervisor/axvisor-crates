# axvisor-crates

Reusable crates list for [AxVisor](https://github.com/arceos-hypervisor/axvisor).

## Crate List

| Crate                                                           |                                      [crates.io](crates.io)                                       |                                 Documentation                                  | Description                                              |
| --------------------------------------------------------------- | :-----------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------: | -------------------------------------------------------- |
| [arm_vcpu](https://github.com/arceos-hypervisor/arm_vcpu)       |                                                N/A                                                |                                      N/A                                       | .                                                        |
| [arm_vgic](https://github.com/arceos-hypervisor/arm_vgic)       |                                                N/A                                                |                                      N/A                                       | .                                                        |
| [arm_gicv2](https://github.com/arceos-hypervisor/arm_gicv2)     |                                                N/A                                                |                                      N/A                                       | .                                                        |
| [x86_vcpu](https://github.com/arceos-hypervisor/x86_vcpu)       |                                                N/A                                                |                                      N/A                                       | .                                                        |
| [x86_vlapic](https://github.com/arceos-hypervisor/x86_vlapic)   |                                                N/A                                                |                                      N/A                                       | x86 Virtual Local APIC.                                  |
| [riscv_vcpu](https://github.com/arceos-hypervisor/riscv_vcpu)   |                                                N/A                                                |                                      N/A                                       | .                                                        |
| [axvisor_api](https://github.com/arceos-hypervisor/axvisor_api) | [![Crates.io](https://img.shields.io/crates/v/axvisor_api)](https://crates.io/crates/axvisor_api) | [![Docs.rs](https://docs.rs/arm_gicv2/badge.svg)](https://docs.rs/axvisor_api) | Experimental Next-Generation Axvisor API                 |
| [axaddrspace](https://github.com/arceos-hypervisor/axaddrspace) | [![Crates.io](https://img.shields.io/crates/v/axaddrspace)](https://crates.io/crates/axaddrspace) | [![Docs.rs](https://docs.rs/arm_gicv2/badge.svg)](https://docs.rs/axaddrspace) | ArceOS-Hypervisor guest address space management module. |
| [axdevice_crates](https://github.com/arceos-hypervisor/axdevice_crates)       |                                                N/A                                                |                                      N/A                                       | Crates for building emulated device subsystems for ArceOS-hypervisor in the `no_std` environment.           |
| [axvmconfig](https://github.com/arceos-hypervisor/axvmconfig)       |                                                N/A                                                |                                      N/A                                       | a Virtual Machine configuration tool and library for AxVisor.           |
| [axvcpu](https://github.com/arceos-hypervisor/axvcpu)       |                                                N/A                                                |                                      N/A                                       | a virtual CPU abstraction library for ArceOS hypervisors.           |
| ~~[axvirtio](https://github.com/arceos-hypervisor/axvirtio)~~   |                                                N/A                                                |                                      N/A                                       | ~~VirtIO device framework for ArceOS-Hypervisor.~~       |

>  **Note: axvirtio is currently not mature enough and will be published once ready.**


## Crate Dependency

![Crate Dependency](./img/dep.jpg)