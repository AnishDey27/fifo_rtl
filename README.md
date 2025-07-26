# Parameterized Synchronous FIFO in Verilog

A robust, reusable, and fully parameterized Synchronous FIFO (First-In, First-Out) memory buffer designed from the ground up in Verilog RTL. This project is a fundamental building block for digital VLSI systems, designed to handle data synchronization between modules operating at the same clock frequency.

This project was developed as part of my journey into digital VLSI design as an undergraduate at Jadavpur University.

---

## 📖 Table of Contents
- [✨ Key Features](#-key-features)
- [🔧 Module Parameters](#-module-parameters)
- [➡️ Port Descriptions](#️-port-descriptions)
- [🏗️ Design Architecture](#️-design-architecture)
- [🔬 Verification](#-verification)
- [🚀 How to Use](#-how-to-use)
- [📁 File Structure](#-file-structure)
- [👤 About the Author](#-about-the-author)

---

## ✨ Key Features

* **Fully Parameterized**: Easily configure the `DATA_WIDTH` and `DEPTH` for maximum reusability across different projects.
* **Robust Pointer Logic**: Implements the industry-standard pointer-based method with an extra bit to reliably distinguish between full and empty states. This prevents overflow and underflow conditions.
* **Simultaneous Read/Write**: The design flawlessly handles simultaneous read and write operations in a single clock cycle, ensuring the FIFO level remains stable and no data is lost.
* **Standard Synchronous Interface**: Clean and intuitive ports for data, control (`read_en`, `write_en`), and status (`full`, `empty`, `fifo_level`).
* **Registered Output**: Provides a stable data output, simplifying timing closure in larger systems.

---

## 🔧 Module Parameters

The behavior of the FIFO can be customized using the following parameters during instantiation:

| Parameter      | Default Value | Description                                                    |
| :------------- | :------------ | :------------------------------------------------------------- |
| `DATA_WIDTH`   | 8             | Defines the width of the data bus in bits.                     |
| `DEPTH`        | 8             | Defines the number of words the FIFO can store. Must be a power of 2. |

---

## ➡️ Port Descriptions

| Port         | Direction | Width              | Description                                                |
| :----------- | :-------- | :----------------- | :--------------------------------------------------------- |
| `clk`        | Input     | 1-bit              | System clock.                                              |
| `rst_n`      | Input     | 1-bit              | Active-low asynchronous reset.                             |
| `write_en`   | Input     | 1-bit              | Write enable signal. A high pulse writes `data_in` to the FIFO. |
| `data_in`    | Input     | `DATA_WIDTH`       | Data to be written into the FIFO.                          |
| `read_en`    | Input     | 1-bit              | Read enable signal. A high pulse reads from the FIFO.      |
| `data_out`   | Output    | `DATA_WIDTH`       | Data read from the FIFO.                                   |
| `fifo_full`  | Output    | 1-bit              | Flag indicating the FIFO is full.                          |
| `fifo_empty` | Output    | 1-bit              | Flag indicating the FIFO is empty.                         |
| `fifo_level` | Output    | `$clog2(DEPTH)+1`  | Indicates the number of items currently in the FIFO.       |

---

## 🏗️ Design Architecture

The FIFO operates on a single clock domain and uses a dual-pointer architecture.

* **Memory**: A simple register array (`reg [DATA_WIDTH-1:0] memory [DEPTH-1:0];`) is used as the storage element.
* **Pointers**: A `wr_ptr` (write pointer) and `rd_ptr` (read pointer) track the location of the next write and read operations. To differentiate between the full and empty conditions when `wr_ptr == rd_ptr`, the pointers are designed to be one bit wider than the address space (`$clog2(DEPTH) + 1`). This extra bit acts as a lap counter, allowing for unambiguous status detection.

---

## 🔬 Verification

The design was rigorously verified using a structured, task-based testbench in Verilog. The simulation was performed using Xilinx Vivado.

The test sequence covers the following key scenarios:
* System Reset
* Writing to fill the FIFO completely.
* Reading from a full FIFO until it is empty.
* Simultaneous read and write operations to test data stability and level tracking.
* Boundary checks for `fifo_full` and `fifo_empty` flags.

### Simulation Waveform
<img width="1823" height="427" alt="waveform" src="https://github.com/user-attachments/assets/24f11a33-9452-4f81-ace9-7f11a0d10529" />

The waveform confirms that all signals behave as expected, including the 1-cycle read latency due to the registered output and the stable `fifo_level` during simultaneous read/write operations.

---

## 🚀 How to Use

Instantiate the `fifo_rtl` module in your Verilog project as shown below. Remember to connect the ports and customize the parameters as needed.

```verilog
fifo_rtl #(
    .DATA_WIDTH(16), // Example: 16-bit data
    .DEPTH(32)       // Example: 32 words deep
) my_fifo_instance (
    .clk(your_clk),
    .rst_n(your_rst_n),
    .write_en(your_write_en),
    .data_in(your_data_in),
    .read_en(your_read_en),
    .data_out(your_data_out),
    .fifo_full(fifo_is_full),
    .fifo_empty(fifo_is_empty),
    .fifo_level(current_fifo_level)
);
```

---

## 📁 File Structure
```
.
├── fifo_rtl.v         // Main parameterized FIFO module
└── fifo_rtl_tb.v      // Verilog testbench for verification
```

---

## 👤 About the Author

**Anish Dey**

A passionate VLSI enthusiast and undergraduate student pursuing a B.E. in Electronics & Tele-communication Engineering at Jadavpur University, Kolkata. My interests lie in both analog and digital circuit design, embedded systems, and hardware architecture.

[Connect with me on LinkedIn!](https://www.linkedin.com/in/deyanish/)
