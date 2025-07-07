# UART

---
# UART Protocol Design in Verilog HDL

## 🧠 What is UART?

**UART (Universal Asynchronous Receiver/Transmitter)** is a widely used serial communication protocol. It enables **asynchronous**, **full-duplex**, **point-to-point communication** between two devices without requiring a shared clock. UART is commonly used in microcontrollers, embedded systems, and computer serial ports (RS-232).

---

## 📶 UART Protocol Overview

### 🧩 Key Concepts:
- **Asynchronous Communication**: No clock is shared; synchronization is done using start and stop bits.
- **Full Duplex**: Both transmission and reception can occur simultaneously.
- **Serial Data Format**:


### 🔧 UART Frame Format:
| Bit | Name       | Purpose                          |
|-----|------------|----------------------------------|
| 1   | Start Bit  | Indicates the beginning of frame |
| 5-8 | Data Bits  | Actual data (5 to 8 bits)        |
| 0/1 | Parity Bit | Optional error detection         |
| 1   | Stop Bit   | Indicates end of transmission    |

---

## 🛠️ Project Structure
uart_project/
│
├── uart/ # Top-level UART modules
│ ├── uart_tx.v # Transmitter module
│ ├── uart_rx.v # Receiver module
│
│ ├── parity_calc.v # Parity calculator (TX)
│ ├── serializer.v # Parallel to serial converter (TX)
│ ├── tx_fsm.v # Finite State Machine for TX
│ ├── mux.v # TX multiplexer for output selection
│
│ ├── data_sampling.v # RX sampling logic for noise handling
│ ├── deserializer.v # Serial to parallel converter (RX)
│ ├── edge_bit_counter.v # Timing control for sampling bits
│ ├── rx_fsm.v # RX FSM to manage RX states
│ ├── start_check.v # Detects the start bit
│ ├── parity_check.v # Validates parity
│ ├── stop_check.v # Checks stop bit validity
│
├── sim_1/ # Testbenches
│ ├── uart_tb.v # Full UART testbench (TX + RX)
│ ├── uart_tx_tb.v # TX testbench
│ ├── uart_rx_tb.v # RX testbench
│
├── constrs_1/
│ └── zedboard_constraints.xdc # Xilinx ZedBoard I/O pin mapping

## ⚙️ Working Principle

### 📤 UART Transmitter (TX)
- Adds **start**, **parity**, and **stop** bits to the parallel input data.
- Uses **serializer** to send the data serially (bit by bit).
- Controlled by **`tx_fsm.v`**, which handles TX states (IDLE → START → DATA → PARITY → STOP).

### 📥 UART Receiver (RX)
- Uses **data sampling** to ensure reliable reception.
- Detects **start bit** → receives **data bits** → checks **parity and stop bit**.
- Managed by **`rx_fsm.v`**, which handles RX states and coordinates deserialization.

---

## 💻 Simulation

Each module is thoroughly verified using Verilog testbenches:

| Testbench       | Description                           |
|-----------------|---------------------------------------|
| `uart_tb.v`     | Full TX-RX loop simulation            |
| `uart_tx_tb.v`  | Transmitter functional test           |
| `uart_rx_tb.v`  | Receiver functional and error tests   |

✅ You can run the simulations using **Vivado**, **ModelSim**, or **Icarus Verilog**.

---

## 🎯 Features

- Fully modular UART design
- Separate FSMs for TX and RX
- Configurable parity check
- Bit-accurate sampling logic
- Verilog testbenches for individual and integrated verification
- Xilinx constraints provided for hardware implementation

---

## 📈 Applications

- Embedded systems (Microcontrollers, SoCs)
- Serial communication between PC and peripherals
- Debug interfaces
- Bluetooth, GPS modules, etc.

---

## 💡 Possible Extensions

- Add **configurable baud rate generator**
- Add **FIFO buffers** for TX and RX
- Extend to **multi-byte frame support**
- Support for **multiple stop bits** and **different parity types**

---

## ⚡ FPGA Implementation

To synthesize and deploy this project on a Xilinx ZedBoard:
1. Import all `uart/` modules into Vivado.
2. Add `zedboard_constraints.xdc` file under constraints.
3. Use the `uart.v` top module for pin mapping.
4. Connect TX and RX lines to PMOD UART or USB-UART bridge.

---

## 👨‍💻 Author

This project is developed by **Chandrakiran G.**  
📌 VLSI Design Enthusiast 
📫 GitHub: [Kiran-VLSI](https://github.com/Kiran-VLSI)

---

## 📝 License

This project is licensed under the **MIT License** - you are free to use, modify, and distribute with attribution.

---

## 🙏 Acknowledgment

Special thanks to the **open-source VLSI community** and the **100-Days RTL Challenge** for motivation and technical inspiration.

---

## 📬 Feedback

Found a bug or need help? Feel free to raise an issue or open a pull request!
