//
//  FieldView.swift
//  DynamicForms
//
//  Created by Caio Cesar Franco Fausto de Freitas on 27/02/25.
//

import SwiftUI


struct FieldView: View {
    let field: Field
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            switch field.type.lowercased() {
            case "description":
                DescriptionField(label: field.label)
            case "dropdown":
                DropdownField(field: field, value: $value)
            case "number":
                NumberField(field: field, value: $value)
            default:
                TextFieldView(field: field, value: $value)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Subcomponents
private struct DescriptionField: View {
    let label: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            AttributedText(html: label)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct DropdownField: View {
    let field: Field
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Adicione o label do campo aqui
            Text(field.label)
                .font(.subheadline)
            
            Menu {
                ForEach(field.options, id: \.optionId) { option in
                    Button(option.label) {
                        value = option.value
                    }
                }
            } label: {
                HStack {
                    Text(selectedLabel())
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
        }
    }
    
    private func selectedLabel() -> String {
        field.options.first { $0.value == value }?.label ?? "Selecione..."
    }
}

private struct NumberField: View {
    let field: Field
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
            
            TextField("Ex: 42", text: $value)
                .keyboardType(.decimalPad)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .onChange(of: value) {_,  newValue in
                    value = newValue.filter { $0.isNumber }
                }
        }
    }
}

private struct TextFieldView: View {
    let field: Field
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(field.label)
                .font(.subheadline)
            
            TextField("Insira texto...", text: $value)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
    }
}
