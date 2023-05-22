# EMG_Pipelines


## Pipelines

| Pipeline Name | Signal averaging                              | Feature of interest                                                           | Baseline correction                                                          | Standardization within muscle         | Standardization within subjects         | Data reduction                            |
| ------------- | --------------------------------------------- | ----------------------------------------------------------------------------- | ---------------------------------------------------------------------------- | ------------------------------------- | --------------------------------------- | ----------------------------------------- |
| Explanation   | Raw  \= None; Average = Average across trials | RMS = Root Mean Square; MAV = Mean Absolute Value; AUC = Area Under the Curve | 0 = None; Subtraction = Subtract the baseline; Division = Divide by baseline | 0 = None; M = z-scoring within muscle | 0 = None; S = z-scoring within subjects | 0 = None; Average = Average across trials |
| R_RMS_000     | Raw                                           | RMS                                                                           | 0                                                                            | 0                                     | 0                                       | Average                                   |
| R_RMS_S00     | Raw                                           | RMS                                                                           | Subtraction                                                                  | 0                                     | 0                                       | Average                                   |
| R_RMS_D00     | Raw                                           | RMS                                                                           | Division                                                                     | 0                                     | 0                                       | Average                                   |
| R_RMS_0M0     | Raw                                           | RMS                                                                           | 0                                                                            | M                                     | 0                                       | Average                                   |
| R_RMS_SM0     | Raw                                           | RMS                                                                           | Subtraction                                                                  | M                                     | 0                                       | Average                                   |
| R_RMS_DM0     | Raw                                           | RMS                                                                           | Division                                                                     | M                                     | 0                                       | Average                                   |
| R_RMS_00S     | Raw                                           | RMS                                                                           | 0                                                                            | 0                                     | S                                       | Average                                   |
| R_RMS_S0S     | Raw                                           | RMS                                                                           | Subtraction                                                                  | 0                                     | S                                       | Average                                   |
| R_RMS_D0S     | Raw                                           | RMS                                                                           | Division                                                                     | 0                                     | S                                       | Average                                   |
| R_RMS_0MS     | Raw                                           | RMS                                                                           | 0                                                                            | M                                     | S                                       | Average                                   |
| R_RMS_SMS     | Raw                                           | RMS                                                                           | Subtraction                                                                  | M                                     | S                                       | Average                                   |
| R_RMS_DMS     | Raw                                           | RMS                                                                           | Division                                                                     | M                                     | S                                       | Average                                   |
| R_AUC_000     | Raw                                           | AUC                                                                           | 0                                                                            | 0                                     | 0                                       | Average                                   |
| R_AUC_S00     | Raw                                           | AUC                                                                           | Subtraction                                                                  | 0                                     | 0                                       | Average                                   |
| R_AUC_D00     | Raw                                           | AUC                                                                           | Division                                                                     | 0                                     | 0                                       | Average                                   |
| R_AUC_0M0     | Raw                                           | AUC                                                                           | 0                                                                            | M                                     | 0                                       | Average                                   |
| R_AUC_SM0     | Raw                                           | AUC                                                                           | Subtraction                                                                  | M                                     | 0                                       | Average                                   |
| R_AUC_DM0     | Raw                                           | AUC                                                                           | Division                                                                     | M                                     | 0                                       | Average                                   |
| R_AUC_00S     | Raw                                           | AUC                                                                           | 0                                                                            | 0                                     | S                                       | Average                                   |
| R_AUC_S0S     | Raw                                           | AUC                                                                           | Subtraction                                                                  | 0                                     | S                                       | Average                                   |
| R_AUC_D0S     | Raw                                           | AUC                                                                           | Division                                                                     | 0                                     | S                                       | Average                                   |
| R_AUC_0MS     | Raw                                           | AUC                                                                           | 0                                                                            | M                                     | S                                       | Average                                   |
| R_AUC_SMS     | Raw                                           | AUC                                                                           | Subtraction                                                                  | M                                     | S                                       | Average                                   |
| R_AUC_DMS     | Raw                                           | AUC                                                                           | Division                                                                     | M                                     | S                                       | Average                                   |
| R_MAV_000     | Raw                                           | MAV                                                                           | 0                                                                            | 0                                     | 0                                       | Average                                   |
| R_MAV_S00     | Raw                                           | MAV                                                                           | Subtraction                                                                  | 0                                     | 0                                       | Average                                   |
| R_MAV_D00     | Raw                                           | MAV                                                                           | Division                                                                     | 0                                     | 0                                       | Average                                   |
| R_MAV_0M0     | Raw                                           | MAV                                                                           | 0                                                                            | M                                     | 0                                       | Average                                   |
| R_MAV_SM0     | Raw                                           | MAV                                                                           | Subtraction                                                                  | M                                     | 0                                       | Average                                   |
| R_MAV_DM0     | Raw                                           | MAV                                                                           | Division                                                                     | M                                     | 0                                       | Average                                   |
| R_MAV_00S     | Raw                                           | MAV                                                                           | 0                                                                            | 0                                     | S                                       | Average                                   |
| R_MAV_S0S     | Raw                                           | MAV                                                                           | Subtraction                                                                  | 0                                     | S                                       | Average                                   |
| R_MAV_D0S     | Raw                                           | MAV                                                                           | Division                                                                     | 0                                     | S                                       | Average                                   |
| R_MAV_0MS     | Raw                                           | MAV                                                                           | 0                                                                            | M                                     | S                                       | Average                                   |
| R_MAV_SMS     | Raw                                           | MAV                                                                           | Subtraction                                                                  | M                                     | S                                       | Average                                   |
| R_MAV_DMS     | Raw                                           | MAV                                                                           | Division                                                                     | M                                     | S                                       | Average                                   |
| A_RMS_000     | Average                                       | RMS                                                                           | 0                                                                            | 0                                     | 0                                       | 0                                         |
| A_RMS_S00     | Average                                       | RMS                                                                           | Subtraction                                                                  | 0                                     | 0                                       | 0                                         |
| A_RMS_D00     | Average                                       | RMS                                                                           | Division                                                                     | 0                                     | 0                                       | 0                                         |
| A_RMS_0M0     | Average                                       | RMS                                                                           | 0                                                                            | M                                     | 0                                       | 0                                         |
| A_RMS_SM0     | Average                                       | RMS                                                                           | Subtraction                                                                  | M                                     | 0                                       | 0                                         |
| A_RMS_DM0     | Average                                       | RMS                                                                           | Division                                                                     | M                                     | 0                                       | 0                                         |
| A_RMS_00S     | Average                                       | RMS                                                                           | 0                                                                            | 0                                     | S                                       | 0                                         |
| A_RMS_S0S     | Average                                       | RMS                                                                           | Subtraction                                                                  | 0                                     | S                                       | 0                                         |
| A_RMS_D0S     | Average                                       | RMS                                                                           | Division                                                                     | 0                                     | S                                       | 0                                         |
| A_RMS_0MS     | Average                                       | RMS                                                                           | 0                                                                            | M                                     | S                                       | 0                                         |
| A_RMS_SMS     | Average                                       | RMS                                                                           | Subtraction                                                                  | M                                     | S                                       | 0                                         |
| A_RMS_DMS     | Average                                       | RMS                                                                           | Division                                                                     | M                                     | S                                       | 0                                         |
| A_AUC_000     | Average                                       | AUC                                                                           | 0                                                                            | 0                                     | 0                                       | 0                                         |
| A_AUC_S00     | Average                                       | AUC                                                                           | Subtraction                                                                  | 0                                     | 0                                       | 0                                         |
| A_AUC_D00     | Average                                       | AUC                                                                           | Division                                                                     | 0                                     | 0                                       | 0                                         |
| A_AUC_0M0     | Average                                       | AUC                                                                           | 0                                                                            | M                                     | 0                                       | 0                                         |
| A_AUC_SM0     | Average                                       | AUC                                                                           | Subtraction                                                                  | M                                     | 0                                       | 0                                         |
| A_AUC_DM0     | Average                                       | AUC                                                                           | Division                                                                     | M                                     | 0                                       | 0                                         |
| A_AUC_00S     | Average                                       | AUC                                                                           | 0                                                                            | 0                                     | S                                       | 0                                         |
| A_AUC_S0S     | Average                                       | AUC                                                                           | Subtraction                                                                  | 0                                     | S                                       | 0                                         |
| A_AUC_D0S     | Average                                       | AUC                                                                           | Division                                                                     | 0                                     | S                                       | 0                                         |
| A_AUC_0MS     | Average                                       | AUC                                                                           | 0                                                                            | M                                     | S                                       | 0                                         |
| A_AUC_SMS     | Average                                       | AUC                                                                           | Subtraction                                                                  | M                                     | S                                       | 0                                         |
| A_AUC_DMS     | Average                                       | AUC                                                                           | Division                                                                     | M                                     | S                                       | 0                                         |
| A_MAV_000     | Average                                       | MAV                                                                           | 0                                                                            | 0                                     | 0                                       | 0                                         |
| A_MAV_S00     | Average                                       | MAV                                                                           | Subtraction                                                                  | 0                                     | 0                                       | 0                                         |
| A_MAV_D00     | Average                                       | MAV                                                                           | Division                                                                     | 0                                     | 0                                       | 0                                         |
| A_MAV_0M0     | Average                                       | MAV                                                                           | 0                                                                            | M                                     | 0                                       | 0                                         |
| A_MAV_SM0     | Average                                       | MAV                                                                           | Subtraction                                                                  | M                                     | 0                                       | 0                                         |
| A_MAV_DM0     | Average                                       | MAV                                                                           | Division                                                                     | M                                     | 0                                       | 0                                         |
| A_MAV_00S     | Average                                       | MAV                                                                           | 0                                                                            | 0                                     | S                                       | 0                                         |
| A_MAV_S0S     | Average                                       | MAV                                                                           | Subtraction                                                                  | 0                                     | S                                       | 0                                         |
| A_MAV_D0S     | Average                                       | MAV                                                                           | Division                                                                     | 0                                     | S                                       | 0                                         |
| A_MAV_0MS     | Average                                       | MAV                                                                           | 0                                                                            | M                                     | S                                       | 0                                         |
| A_MAV_SMS     | Average                                       | MAV                                                                           | Subtraction                                                                  | M                                     | S                                       | 0                                         |
| A_MAV_DMS     | Average                                       | MAV                                                                           | Division                                                                     | M                                     | S                                       | 0                                         |
