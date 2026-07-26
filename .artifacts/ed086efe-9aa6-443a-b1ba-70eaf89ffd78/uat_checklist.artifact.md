# UAT Checklist - Farmer & Farm Modules

User Acceptance Testing checklist for verifying Farmer and Farm functionality in the mobile application.

| ID | Scenario | Description | Expected Result | Status |
|:---|:---|:---|:---|:---|
| **F-01** | **Create Farmer (Valid)** | Fill form with valid data and save. | Farmer created, returns to list, list refreshed. | NOT TESTED |
| **F-02** | **Create Farmer (Invalid)** | Try to save with missing mandatory fields. | Validation errors shown, Save button turns red. | NOT TESTED |
| **F-03** | **Duplicate Identity** | Create farmer with existing IdType + IdNumber. | Save blocked, error message "A farmer with this ID... already exists". | NOT TESTED |
| **F-04** | **Reuse Identity** | Delete farmer, then create new with same ID. | Creation successful. | NOT TESTED |
| **F-05** | **Edit Farmer** | Update fields of an existing farmer and save. | Data updated correctly in details and list. | NOT TESTED |
| **F-06** | **Delete Farmer** | Delete an existing farmer. | record becomes dimmed (pending delete), then disappears after sync. | NOT TESTED |
| **F-07** | **Search Behavior** | Search by Name, ID, or Phone in Farmers list. | Results match search text across all fields. | NOT TESTED |
| **F-08** | **Operational Filtering** | Login as FieldSurveyor and check Farmers list. | Farmers linked to farms in assigned Directorate are shown. | NOT TESTED |
| **R-01** | **Create Farm from Farmer** | Navigate to Farm Form from Farmer Card. | Farmer name pre-filled, saved farm redirects to Farm Details. | NOT TESTED |
| **R-02** | **Edit Farm** | Update farm details and save. | Data updated correctly. | NOT TESTED |
| **R-03** | **Delete Farm** | Delete an existing farm. | Record becomes dimmed, then disappears after sync. | NOT TESTED |
| **R-04** | **Farm Details** | Open an existing farm from the list. | All sections (Location, Info, Area, Ownership) displayed correctly. | NOT TESTED |
| **R-05** | **Damage Report Action** | Check Farm Card for "Damage Report" button. | Button present, navigates to Damage Report form. | NOT TESTED |
| **O-01** | **Offline Create** | Disable network, create Farmer/Farm. | Record shown as "Pending Sync", added to Sync Queue. | NOT TESTED |
| **O-02** | **Offline Edit** | Disable network, edit an existing record. | Record shown as "Pending Sync", update added to Queue. | NOT TESTED |
| **O-03** | **Offline Delete** | Disable network, delete a record. | Record shown as "Pending Delete", delete added to Queue. | NOT TESTED |
| **O-04** | **Sync Recovery** | Restore connection after offline ops. | BackgroundSyncService starts, items processed in order. | NOT TESTED |
| **O-05** | **Conflict Handling** | Edit same record on server and client offline. | Client syncs, server data is preserved (Server Wins). | NOT TESTED |
| **S-01** | **SuperAdmin Auth** | Login as SuperAdmin. | Full access to create/edit/delete Farmers and Farms. | NOT TESTED |
| **S-02** | **AgriculturalEngineer Auth** | Login as AgriculturalEngineer. | Access to manage Farms, but restricted to Directorate. | NOT TESTED |
| **S-03** | **FieldSurveyor Auth** | Login as FieldSurveyor. | Cannot manage Farmers (buttons hidden), restricted to Directorate for Farms. | NOT TESTED |
| **S-04** | **TechnicalReviewer Auth** | Login as TechnicalReviewer. | Cannot manage Farmers or Farms. | NOT TESTED |
| **S-05** | **ReadOnly Auth** | Login as ReadOnly. | View access only, no management buttons visible. | NOT TESTED |
