# Trading_Pollution




```mermaid
flowchart TD
    A((Start)) --> B[01_preparing]
    B -->|Uses data from| C[(data/raw)]
    B -->|Saves cleaned data to| D[(data/cleaned)]
    D --> |Uses data to conduct exploratory analysis|E[02_eda]
    E -->|generates network metric datasets| D
    D --> |data goes to|F[03_regressions]
    F -->|runs STERGMs, PPML regressions|H[\results/]
    H -->|stores and displays results|I((End))

```