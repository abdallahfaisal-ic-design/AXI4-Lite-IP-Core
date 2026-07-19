# AMBA AXI4 / AXI4-Lite Master/Slave Interface Implementation

A fully synthesizable, high-performance AMBA AXI4 (Advanced eXtensible Interface) Master and Slave IP core modeled in Verilog HDL. This design implements the advanced, high-bandwidth, low-latency on-chip bus protocol standard, optimizing data throughput for memory-mapped master/slave communication in modern multi-core SoC architectures.

## Key Technical Features
* **Decoupled 5-Channel Architecture:** Strict hardware implementation of the independent AXI channels: Read Address (AR), Read Data (R), Write Address (AW), Write Data (W), and Write Response (B).
* * **Robust VALID/READY Handshaking:** Precise control logic driving the standard `VALID` and `READY` handshake mechanism across all channels to guarantee safe, zero-latency synchronous data transfers.
* * **Parameterized Bus Topologies:** Fully configurable data bus width (`DATA_WIDTH`) and address bus width (`ADDR_WIDTH`), adaptable to standard 32-bit, 64-bit, or custom system designs.
* * **AXI4-Lite & Full Burst Support:** Modular Verilog coding covering light memory-mapped registers (AXI4-Lite) as well as continuous burst transaction logic for high-speed memory streaming.
* * **Concurrent Read/Write Capability:** Decoupled address and data paths enable simultaneous full-duplex read and write execution cycles without structural hazards.
       
* ## Core Modules & Signaling
* * **AXI Master IP:** Drives transfer addresses, controls write data alignment, handles read data collection, and monitors transaction responses.
* * **AXI Slave IP:** Decodes target addresses, manages internal register/memory access, and asserts readiness flags based on internal pipeline states.
           
* ## Simulation & Verification
* * **HDL Language:** Verilog HDL
* * **Simulation Tool:** ModelSim SE
* * **Testbench Methodology:** Rigorous behavioral testbench verifying continuous back-to-back burst transfers, random wait-state insertion via `READY` throttling, and data integrity verification under simultaneous read and write transaction requests.
