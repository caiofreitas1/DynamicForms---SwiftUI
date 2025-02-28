# DynamicForms (iOS)

This repository contains the iOS implementation of a **dynamic forms application**, built using **SwiftUI**, **Core Data**, and the **MVVM architecture**. The application loads forms from JSON files, displays them dynamically, and persists the user’s responses locally.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [How to Run](#how-to-run)
- [Project Structure](#project-structure)

---

## Overview

DynamicForms is an iOS application that dynamically renders forms based on JSON files. It supports various field types (text, number, dropdown, description) and persists the forms and user inputs in **Core Data**. The application loads forms only once, and reuses the saved data for subsequent sessions.

---

## Features

- **Form List Screen**: Displays the list of available forms.
- **Form Entries Screen**: Displays all saved entries for a selected form.
- **Form Entry Screen**: Dynamically renders the form sections and fields, supports different input types.
- **Persistence**: All forms and user responses are saved locally using **Core Data**.

---

## Prerequisites

- **Xcode 14+** (recommended).
- **Swift 5.7+**.

---

## How to Run

1. **Clone the Repository**
    ```bash
    git clone https://github.com/YOUR_GITHUB_USERNAME/DynamicForms-iOS.git
    cd DynamicForms-iOS
    ```

2. **Open in Xcode**
    - Open `DynamicForms.xcodeproj` in Xcode.
    - Make sure the `DynamicForms` target is selected.

3. **Run the Project**
    - Press `Cmd + R` to build and run the project.
    - You should see the form list screen when the app starts.

4. **Verify JSON Resources**
    - Ensure `all_fields.json` and `200-form.json` are correctly added to the project under `Resources`.
    - Confirm that both files have **Target Membership** checked for `DynamicForms`.

---

## Project Structure

```plaintext
DynamicForms
├── App
│   ├── DynamicFormsApp.swift
├── Data
│   ├── Local
│   │   ├── PersistenceController.swift
│   │   ├── FormLocalDataSource.swift
│   │   ├── FormLocalDataSourceImpl.swift
│   │   ├── DynamicFormsModel.xcdatamodeld
│   └── Model
│       ├── FormDto.swift
│       ├── FieldDto.swift
│       ├── OptionDto.swift
│       ├── SectionDto.swift
│       └── EntryDto.swift (optional)
├── Domain
│   ├── Model
│   │   ├── Form.swift
│   │   ├── Field.swift
│   │   ├── Option.swift
│   │   ├── Section.swift
│   │   └── Entry.swift
│   └── Repository
│       └── FormRepository.swift
├── Data
│   └── Repository
│       └── FormRepositoryImpl.swift
├── Presentation
│   ├── FormList
│   │   ├── FormListView.swift
│   │   └── FormListViewModel.swift
│   ├── FormEntries
│   │   ├── FormEntriesView.swift
│   │   └── FormEntriesViewModel.swift
│   ├── FormEntry
│   │   ├── FormEntryView.swift
│   │   └── FormEntryViewModel.swift
│   └── Components
│       ├── FieldView.swift
│       ├── AttributedText.swift
├── Utils
│   ├── FormJsonParser.swift
├── Resources
│   ├── all_fields.json
│   └── 200-form.json
