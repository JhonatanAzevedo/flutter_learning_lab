import 'package:flutter/material.dart';
import 'package:learning_lab/src/utils/cpf_validator.dart';

import '../utils/cnpj_validator.dart';

class ValidationCpfCnpjPage extends StatefulWidget {
  const ValidationCpfCnpjPage({super.key});

  @override
  State<ValidationCpfCnpjPage> createState() => _ValidationCpfCnpjPageState();
}

class _ValidationCpfCnpjPageState extends State<ValidationCpfCnpjPage> {
  final TextEditingController cpfEditingController = TextEditingController();
  final TextEditingController cnpjEditingController = TextEditingController();

  bool isCpfValid = false;
  bool isCnpjValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Digite seu cpf'),
              controller: cpfEditingController,
              onChanged: (value) {
                validatCpfCnpj();
                debugPrint(CPFValidator.generate());
              },
            ),
            if (!isCpfValid) const Text('CPF invalido'),
            const SizedBox(height: 30),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Digite seu cnpj'),
              controller: cnpjEditingController,
              onChanged: (value) {
                validatCpfCnpj();
                debugPrint(CNPJValidator.generate());
              },
            ),
            if (!isCnpjValid) const Text('CNPJ invalido'),
          ],
        ),
      ),
    );
  }

  validatCpfCnpj() {
    setState(() {
      isCpfValid = CPFValidator.isValid(cpfEditingController.text);
      isCnpjValid = CNPJValidator.isValid(cnpjEditingController.text);
    });
  }
}
