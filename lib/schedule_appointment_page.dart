import 'package:flutter/material.dart';

/**
 * This class will display 2 status
 * upcoming appointments  status and complete appointments status
 */

class ScheduleAppointmentPage extends StatefulWidget {
  const ScheduleAppointmentPage({super.key});

  @override
  State<ScheduleAppointmentPage> createState() => _ScheduleAppointmentPageState();
}

//enum for appointment status
enum FilterStatus{upcoming, complete, cancel}

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {

  FilterStatus status = FilterStatus.upcoming; // Initial status
  Alignment _alignment = Alignment.centerLeft;
  List<dynamic> schedules = [
    {
      "service_type": "Regular Checkup",
      "appointment_date":"21-12-2023",
      "appointment_time":"9:00 am",
      "status": FilterStatus.upcoming,
    },
    {
      "service_type": "Dental Checkup",
      "appointment_date":"21-12-2023",
      "appointment_time":"10:00 am",
      "status": FilterStatus.upcoming,
    },
    {
      "service_type": "Regular Checkup",
      "appointment_date":"5-10-2023",
      "appointment_time":"10:00 am",
      "status": FilterStatus.complete,
    },
    {
      "service_type": "Regular Checkup",
      "appointment_date":"10-11-2023",
      "appointment_time":"10:00 am",
      "status": FilterStatus.complete,
    },

    {
      "service_type": "Dental Checkup",
      "appointment_date":"21-12-2023",
      "appointment_time":"10:00 am",
      "status": FilterStatus.cancel,
    }
  ];

  @override
  Widget build(BuildContext context) {
    //returned filtered appointment

  List<dynamic> filteredSchedules = schedules.where((var schedule){
    /*switch(schedule['status']){
      case 'upcoming':
        schedule['status']=FilterStatus.upcoming;
        break;
      case 'complete':
        schedule['status']=FilterStatus.complete;
        break;
      case 'cancel':
        schedule['status']=FilterStatus.cancel;
        break;
    }*/
    return schedule['status']==status;
  }).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: Container(child: const Text("Schedule"),),
      ),
      body: Column(
        children: <Widget>[
         Stack(
           children: [
             const Padding(padding: EdgeInsets.all(8.0),),
             Container(
               width: double.infinity,
               height: 40,
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(20),
               ),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   for(FilterStatus filterStatus in FilterStatus.values)
                     Expanded(child: GestureDetector(
                       onTap: (){
                         setState(() {
                           if(filterStatus == FilterStatus.upcoming){
                             status = FilterStatus.upcoming;
                             _alignment = Alignment.centerLeft;
                           }else if(filterStatus==FilterStatus.complete){
                             status = FilterStatus.complete;
                             _alignment = Alignment.center;
                           }else if(filterStatus==FilterStatus.cancel){
                             status = FilterStatus.cancel;
                             _alignment = Alignment.centerRight;
                           }
                         });
                       },
                       child: Center(
                         child: Text(filterStatus.name),
                       ),
                     ))
                 ],
               ),
             ),
             AnimatedAlign(alignment: _alignment,
                 duration: const Duration(milliseconds: 200),
             child: Container(
               width: 100,
               height: 40,
               decoration: BoxDecoration(
                 color: Colors.deepPurple[200],
                 borderRadius: BorderRadius.circular(20),
               ),
               child: Center(
                 child: Text(
                   status.name,
                   style: const TextStyle(
                     color: Colors.white,
                     fontWeight: FontWeight.bold,

                   ),
                 ),
               ),
             ),)
           ],
         ),
          Expanded(child: ListView.builder(
            itemCount: filteredSchedules.length,
              itemBuilder: ((context, index){
                var _schedule = filteredSchedules[index];
                bool isLasElement = filteredSchedules.length + 1 == index;
                return Card(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /*if(_schedule['service_type']=='Regular Checkup')
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage: AssetImage("assets/regular_checkup.png"),
                              ),
                            ],
                          ),
                        if(_schedule['service_type']=='Dental Checkup')
                          const CircleAvatar(
                            backgroundImage: AssetImage("assets/dental_checkup.jpg"),
                          ),s
                         */
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _schedule['service_type'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                const Text('Date: ', style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),),
                                Text(
                                  _schedule['appointment_date'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('Time: ', style: TextStyle(
                                color: Colors.black,
                                  fontWeight: FontWeight.bold,),
                  ),
                                Text(
                                  _schedule['appointment_time'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              })))
        ],
      ),
    );
  }









}
