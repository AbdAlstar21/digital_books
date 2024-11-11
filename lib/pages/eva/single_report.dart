import 'package:digital_books/pages/components/progres.dart';
import 'package:digital_books/pages/config.dart';
import 'package:digital_books/pages/eva/report_data.dart';
import 'package:digital_books/pages/eva/reports.dart';
import 'package:digital_books/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../function.dart';

class SingleEva extends StatefulWidget {
  int rep_index;
  EvaData reports;
  SingleEva({
    required this.rep_index,
    required this.reports,
  });
  @override
  _SingleEvaState createState() => _SingleEvaState();
}

class _SingleEvaState extends State<SingleEva> {
  bool isloading = false;

  TextEditingController txtrep_note = TextEditingController();

  updateReport(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    load.add_loading();
    if (txtrep_note.text.isNotEmpty) {
      isloading = true;
      load.add_loading();
      Map arr = {
        "rep_id": widget.reports.rep_id,
        "rep_note": txtrep_note.text,
      };
      bool res = await SaveData(
          arr, "reports/update_rep.php", context, () => Eva(), "update");
      evaList![widget.rep_index].rep_not = txtrep_note.text;

      isloading = res;
      load.add_loading();
    } else {
      Toast.show("Please fill data", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  _displayDialog(BuildContext context, LoadingControl load) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('AlertDemo with TextField '),
            content: TextField(
              controller: txtrep_note,
              decoration: InputDecoration(hintText: "Enter Text"),
            ),
            actions: [
              MaterialButton(
                child: Text('SUBMIT'),
                onPressed: () {
                  updateReport(context, load);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    txtrep_note.dispose();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    txtrep_note.text = widget.reports.rep_not;
  }

  @override
  Widget build(BuildContext context) {
    var providerreport = Provider.of<LoadingControl>(context);
    return Consumer<LoadingControl>(builder: (context, load, child) {
      return MaterialButton(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        onPressed: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => BooksReport(
          //             rep_id: reports.rep_id, rep_name: reports.rep_not)));
        },
        child: Card(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.star,
                  size: 55,
                  color: Colors.amber,
                ),
                title: Text(
                  widget.reports.rep_not,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(widget.reports.rep_date),
                trailing: GestureDetector(
                  onTap: () {
                    evaList!.removeAt(widget.rep_index);
                    deleteData("rep_id", widget.reports.rep_id,
                        "reports/delete_rep.php");
                    providerreport.add_loading();
                  },
                  child: Container(
                    // margin:const EdgeInsets.only(top:5),
                    padding: const EdgeInsets.all(6),
                    // margin: const EdgeInsets.only(top: 20),

                    child: const Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 255, 188, 5),
                      size: 24,
                    ),
                    decoration: BoxDecoration(
                        color: pcBlue,
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),

                // trailing: SizedBox(
                //   width: 30.0,
                //   child: Row(
                //     children: <Widget>[
                //       GestureDetector(
                //         onTap: () {
                //           _displayDialog(context, load);

                //           // Navigator.push(
                //           //     context,
                //           //     MaterialPageRoute(
                //           //         builder: (context) => EditReport(
                //           //             rep_index: widget.rep_index, myreport: widget.reports)));
                //         },
                //         child: Container(
                //           padding: const EdgeInsets.all(5),
                //           child: const Icon(
                //             Icons.edit,
                //             color: Colors.white,
                //             size: 16,
                //           ),
                //           decoration: BoxDecoration(
                //               color: Colors.blue,
                //               borderRadius: BorderRadius.circular(5.0)),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ),
              // Divider(
              //   color: Colors.grey[500],
              // )
            ],
          ),
        ),
      );
    });
  }
}
