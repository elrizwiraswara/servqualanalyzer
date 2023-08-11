import 'package:flutter/material.dart';
import 'package:servqual_analyzer/models.dart';
import 'package:servqual_analyzer/result.dart';
import 'package:servqual_analyzer/values.dart';

class Fields extends StatefulWidget {
  const Fields({Key? key}) : super(key: key);

  @override
  State<Fields> createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Input Data',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          analyzeButton(),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width < 1000 ? 1000 : MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                body(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        nDataField(),
        const Padding(
          padding: EdgeInsets.only(left: 18, top: 18),
          child: Text(
            'Data Hasil Kuesioner',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          width: double.infinity,
          child: Row(
            children: [
              harapanTable(),
              const SizedBox(width: 12),
              kenyataanTable(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              addRemoveButton(),
              // analyzeButton(),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget analyzeButton() {
    return GestureDetector(
      child: Row(
        children: const [
          Icon(
            Icons.analytics,
            color: Colors.white,
            size: 14,
          ),
          SizedBox(width: 8),
          Text(
            'Mulai Analisis Data',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 12),
          Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 18,
          ),
          SizedBox(width: 18),
        ],
      ),
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (contex) => const Result(),
          ),
        );
      },
    );
  }

  Widget addRemoveButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 12, 12, 12),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 14,
                ),
                SizedBox(width: 6),
                Text(
                  'Tambah Field',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            statementsH.add(
              StatementModel(
                i: statementsH.length + 1,
                dimension: dimensions[0],
                likerts: [
                  ...List.generate(
                    likertNames.length,
                    (index) => TextEditingController(text: '0'),
                  )
                ],
              ),
            );
            statementsK.add(
              StatementModel(
                i: statementsK.length + 1,
                dimension: dimensions[0],
                likerts: [
                  ...List.generate(
                    likertNames.length,
                    (index) => TextEditingController(text: '0'),
                  )
                ],
              ),
            );

            setState(() {});
          },
        ),
        const SizedBox(width: 6),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 12, 12, 12),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.red.shade700,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'Hapus Field',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            statementsH.removeLast();
            statementsK.removeLast();

            setState(() {});
          },
        ),
      ],
    );
  }

  Widget kenyataanTable() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: const Text(
                'Kenyataan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...List.generate(
              statementsK.length,
              (i) => fieldContainer(i, FieldTypes.kenyataan),
            ),
          ],
        ),
      ),
    );
  }

  Widget harapanTable() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: const Text(
                'Harapan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...List.generate(
              statementsH.length,
              (i) => fieldContainer(i, FieldTypes.harapan),
            ),
          ],
        ),
      ),
    );
  }

  Widget nDataField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 24, 12, 8),
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0, left: 8),
            child: Text(
              'Jumlah Data (n)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(6, 0, 0, 0),
            // padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                width: 1,
                color: Colors.black.withOpacity(0.08),
              ),
            ),
            child: TextField(
              controller: dataCount,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(13),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget fieldContainer(
    int i,
    FieldTypes type,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, i == 0 ? 0 : 6, 8, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              i == 0
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 2),
                      child: Text(
                        type == FieldTypes.harapan ? 'Hx' : 'Kx',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.all(10),
                constraints: const BoxConstraints(minWidth: 50),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: type == FieldTypes.harapan ? Colors.red.shade200 : Colors.green.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type == FieldTypes.harapan ? 'H${i + 1}' : 'K${i + 1}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              i == 0
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 8.0, left: 2),
                      child: Text(
                        'Dimensi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 6, 4, 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButton<DimensionModel>(
                  value: type == FieldTypes.kenyataan ? statementsH[i].dimension : statementsK[i].dimension,
                  isDense: true,
                  underline: Container(),
                  items: dimensions.map((DimensionModel value) {
                    return DropdownMenuItem<DimensionModel>(
                      value: value,
                      child: Text(
                        value.text,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      if (type == FieldTypes.kenyataan) {
                        statementsH[i].dimension = value!;
                      } else {
                        statementsK[i].dimension = value!;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          ...List.generate(
            likertNames.length,
            (n) => Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  i == 0
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, left: 8),
                          child: Text(
                            likertNames[n],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  Container(
                    margin: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      controller: type == FieldTypes.kenyataan ? statementsH[i].likerts[n] : statementsK[i].likerts[n],
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(13),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
