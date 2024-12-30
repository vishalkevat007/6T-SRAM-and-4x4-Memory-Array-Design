# Performance Analysis of 6T SRAM and Design of 4x4 Memory Array

## Overview
This project focuses on the performance analysis of a 6T SRAM cell and the design of a 4x4 memory array with peripheral circuits. The implementation is carried out in the 45 nm technology node, ensuring efficient operation and scalability. The peripheral circuits include a sense amplifier, row decoder, precharge, and write driver circuit, which are essential for the functionality of the memory array.

## Key Features
- **6T SRAM Analysis:**
  - Evaluated critical performance parameters, including:
    - Read and write delay
    - DC power consumption
    - Static noise margins

- **4x4 Memory Array Design:**
  - Developed a compact and efficient 4x4 memory array.
  - Integrated peripheral circuits:
    - Sense amplifier
    - Row decoder
    - Precharge circuit
    - Write driver circuit

- **Technology Node:** 45 nm in **Cadence Virtuoso**

## Methodology
1. **Performance Analysis:**
   - Simulated the 6T SRAM cell to determine read and write delay, DC power, and noise margins.
   - Conducted transient and steady-state simulations for accuracy.

2. **Memory Array Design:**
   - Designed and verified a 4x4 memory array with optimized layout.
   - Implemented peripheral circuits to support memory operations.

3. **Tools Used:**
   - **Cadence Virtuoso** for schematic entry, layout design, and simulation.
   - **MATLAB** scripts for data analysis and automation.

---

## Performance Analysis of 6T SRAM Cell

### Standard 6T SRAM Bitcell

The standard 6T SRAM bitcell comprises two CMOS inverters connected in a positive feedback loop, forming a bistable circuit for storing one bit of data ('1' or '0'). The bitcell includes:

![6T SRAM Bitcell](./images/bitcell.png)

- **Core Components:**
  - Two CMOS inverters connected in a positive feedback loop form a bistable circuit for stable data storage.
  - Two PMOS pull-up devices (M3, M5) and two NMOS pull-down devices (M4, M6) constitute the cross-coupled inverter pair.
  - Two NMOS pass-gate devices (M1, M2), controlled by the wordline (WL), act as switches connecting the inverters to the bitlines (BL, BLB).

- **Key Features:**
  - Data is stored as complementary values at internal nodes Q and QB.
  - The bitlines (BL, BLB) serve as data lines for reading from or writing to the bitcell.
  - Stored data is retained as long as power is supplied to the cell.

- **Operation:**
  - The cross-coupled inverter pair ensures the stability of the stored data ('1' or '0').
  - The wordline controls the pass-gates, enabling interaction with the bitlines for read and write operations.

---

###  Read Operation

#### Write Operation Steps

1. **Initial Conditions:** Internal storage nodes Q and QB are at '0' and '1', respectively.

2. **Precharging:** Bitlines (BL and BLB) are precharged to the supply voltage ($VDD$) or an intermediate level (0 and VDD).

3. **Wordline Activation:** The wordline (WL) is asserted high, enabling access to the bitcell.

4. **Discharging:** One side of the bitcell (holding '0') discharges its corresponding bitline through the pass-gate and pull-down transistors. If BLB discharges, the bitcell holds a logic '1'.

**Non-Destructive Read:**
   - The internal node holding '0' must not rise above the inverter trip-point to prevent a destructive read.
   - This is ensured by a **large enough** bitcell ratio $β$.

### Transistor Sizing for Successful Read:

**Bitcell Ratio (β):**
   - Defined as:
$$
\beta = \frac{W_4/L_4}{W_1/L_1} = \frac{W_6/L_6}{W_2/L_2}
$$
   - Typically varies from 1.25 to 2.5 based on application and desired static noise margin (SNM).

**Stability Trade-Offs:** 
   - Larger β provides higher SNM, faster read speed, and robustness but increases silicon area and leakage current.
   - Smaller β makes the bitcell compact for high-density cache designs but more susceptible to process variation failures.

---
   
### Write Operation

The write operation in an SRAM bitcell involves flipping the stored data. The following is the explanation for *writing "1"* logic into the SRAM which in turn emphasises the need for stronger access transistors

#### Write Operation Steps:

1. **Initial Conditions:** Internal nodes Q and QB are assumed to hold logic ‘0’ and ‘1’, respectively. Wordline (WL) is initially low ($WL = 0$).

2. **Data Placement:** The new data is placed on BL, and its complement on BLB. i.e BL is kept at $VDD$ and BLB to 0

3. **Wordline Activation:** The wordline (WL) is asserted high and hence bit lines BL and BLB are connected to the SRAM cell through the access transistors M1 and M2.

4. **Node Flipping:**
   - Node QB is pulled below the trip point of inverter INV-1, initiating a feedback loop in the cross-coupled inverters.
   - As Q and QB flip states, WL is de-asserted ($WL = 0$).

### Transistor Sizing for Successful Write:

**Pull-Up Ratio (PR):**
  $$
  PR = \frac{W_3/L_3}{W_1/L_1} = \frac{W_5/L_5}{W_2/L_2}
  $$
- PR determines the balance between pass-gate transistors (M1, M2) and pull-up transistors (M3, M5).
- A **lower PR value** ensures successful write operations by favoring stronger pass-gate transistors over pull-up transistors.

**Write Challenges**:
- **Pass-Gate vs. Pull-Up Transistors:**
  - During a write operation, there is a "fight" between the pass-gate and pull-up transistors.
  - For example, if writing a logic ‘0’ while the bitcell holds a logic ‘1’:
    - M1 must pull Q low (to ground).
    - M3 attempts to keep Q high (at VDD)).
    - M1 must overpower M3 for a successful write.

**Stability Trade-Offs:** 
   - Wider pass-gate transistors (lower PR) improve write success but reduce **Read SNM**, making the bitcell less stable during read operatons.


###  SRAM Cell Stabilty

#### Hold Static Noise Margin

![HSNM](./images/hold_SNM.png)

#### Read Static Noise Margin

![RSNM](./images/read_SNM.png)

#### Write Static Noise Margin

![WSNM](./images/write_SNM.png)