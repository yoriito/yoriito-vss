# Yoriito VSS

Yoriito VSS is a repository for managing and generating vehicle signal specifications by overlaying Yoriito project-specific signal definitions onto the [COVESA Vehicle Signal Specification (VSS)](https://covesa.github.io/vehicle_signal_specification/).

## Overview

The Yoriito architecture adopts VSS as the data model for vehicle signals.

This repository overlays Yoriito-specific signals as vspec files on top of the standard VSS provided by COVESA, and generates the final VSS artifacts (tree, JSON, CSV).

The generated VSS is referenced by various Yoriito components, including the Yoriito VISS Server and Yoriito Signal Library.

## How to Use

Please see [Yoriito VSS Development Guide](docs/devguide.md).

## References

- [COVESA Vehicle Signal Specification (VSS)](https://covesa.github.io/vehicle_signal_specification/)
- [COVESA Vehicle Information Service Specification (VISS)](https://github.com/COVESA/vehicle-information-service-specification)
- [VSS-tools (vspec processing tools)](https://github.com/COVESA/vss-tools/tree/release/6.0)
