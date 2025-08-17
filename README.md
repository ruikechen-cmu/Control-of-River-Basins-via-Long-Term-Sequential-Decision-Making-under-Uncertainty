# Control of River Basins via Long-Term Sequential Decision Making under Uncertainty

This project implements a **Linear Quadratic Regulator (LQR)** framework for reservoir management under uncertain inflow conditions.  
It provides two modes of operation: **monthly control** and **daily control**, allowing comparison of decision intervals and their effects on balancing storage targets versus user demand.

---

## 📂 Project Structure

- **Monthly Control:**  
  Run sequentially from `A0` → `A1` → `A2`.  

- **Daily Control:**  
  Run sequentially from `B0` → `B1` → `B2`.  

---

## ⚙️ Parameters

Both `A0` and `B0` accept two tunable parameters: **alpha** and **beta**.

- **alpha (α):** Weight on **storage target tracking**  
- **beta (β):** Weight on **user demand satisfaction**

📌 Interpretation:  
- Larger `alpha / beta` → Controller prioritizes keeping the reservoir storage close to the target.  
- Smaller `alpha / beta` → Controller prioritizes matching water release to user demand.  

These parameters allow flexible adjustment of control objectives depending on operational priorities.

---

## ▶️ Running the Models

1. **Monthly Control**
   ```bash
   # Run in order
   python A0.py
   python A1.py
   python A2.py


2. **Daily Control**

   ```bash
   # Run in order
   python B0.py
   python B1.py
   python B2.py
   ```

---

## 📊 Results & Analysis

* **Monthly Control:**
  Highly sensitive to the `alpha/beta` ratio. Provides smoother releases and emphasizes long-term storage balance.

* **Daily Control:**
  Captures short-term inflow fluctuations. Without proper normalization of `alpha/beta`, the controller tends to follow baseline inflows more closely.

---

## 🔮 Future Work

* Explore intermediate update intervals between daily and monthly control.
* Incorporate variance-based normalization of `alpha` and `beta`.
* Extend framework to nonlinear hydrological processes and other basins.

---

## 📖 Reference

This work is based on research conducted at **Carnegie Mellon University, Department of Civil and Environmental Engineering**, and applied to **Millerton Lake at Friant Dam (San Joaquin River, California)**.

```


