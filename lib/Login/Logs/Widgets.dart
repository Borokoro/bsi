import 'package:flutter/material.dart';

class Widgets{

  //LOGIN HERE------------------------------------------------------------------------------------------------------
  Widget loginLogs(BuildContext context, List<bool> successful, List<String> ipList, List<DateTime> date, List<String> attempts){
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.height/2,
          height: (MediaQuery.of(context).size.height/14)*4,
          child: ListView(
            children: [
              for(int a=0;a<attempts.length;a++)
                loginAttempts(context, successful, ipList, date, a),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget loginAttempts(BuildContext context, List<bool> successful, List<String> ipList, List<DateTime> date, int a, ){
    return Container(
      height: MediaQuery.of(context).size.height/14,
      width: MediaQuery.of(context).size.width/10,
      decoration: BoxDecoration(
        color: successful[a]==true ? Colors.green : Colors.red,
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //const SizedBox(width: 0.1),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                ipList[a],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                date[a].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Text(
            successful[a]==true ? 'successful' : 'unsucessfull',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // const SizedBox(width: 1,),
        ],
      ),
    );
  }
//LOGIN END------------------------------------------------------------------------------------------------------

//EDIT START------------------------------------------------------------------------------------------------------
  Widget editLogs(BuildContext context, List<String> ipList, List<DateTime> date, List<String> attempts){
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.height/2,
          height: (MediaQuery.of(context).size.height/14)*4,
          child: ListView(
            children: [
              for(int a=0;a<attempts.length;a++)
                editAttempts(context, ipList, date, a),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget editAttempts(BuildContext context, List<String> ipList, List<DateTime> date, int a, ){
    return Container(
      height: MediaQuery.of(context).size.height/14,
      width: MediaQuery.of(context).size.width/10,
      decoration: BoxDecoration(
        color: Colors.pinkAccent,
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //const SizedBox(width: 0.1),
              Text(
                ipList[a],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                date[a].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

          // const SizedBox(width: 1,),
        ],
      ),
    );
  }
//EDIT END------------------------------------------------------------------------------------------------------

//DELETE START------------------------------------------------------------------------------------------------------
  Widget deleteLogs(BuildContext context, List<String> ipList, List<DateTime> date, List<String> attempts){
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.height/2,
          height: (MediaQuery.of(context).size.height/14)*4,
          child: ListView(
            children: [
              for(int a=0;a<attempts.length;a++)
                deleteAttempts(context, ipList, date, a),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget deleteAttempts(BuildContext context, List<String> ipList, List<DateTime> date, int a, ){
    return Container(
      height: MediaQuery.of(context).size.height/14,
      width: MediaQuery.of(context).size.width/10,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //const SizedBox(width: 0.1),
          Text(
            ipList[a],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            date[a].toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          // const SizedBox(width: 1,),
        ],
      ),
    );
  }
//DELETE END------------------------------------------------------------------------------------------------------

//ADD START------------------------------------------------------------------------------------------------------
  Widget addLogs(BuildContext context, List<String> ipList, List<DateTime> date, List<String> attempts){
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.height/2,
          height: (MediaQuery.of(context).size.height/14)*4,
          child: ListView(
            children: [
              for(int a=0;a<attempts.length;a++)
                addAttempts(context, ipList, date, a),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget addAttempts(BuildContext context, List<String> ipList, List<DateTime> date, int a, ){
    return Container(
      height: MediaQuery.of(context).size.height/14,
      width: MediaQuery.of(context).size.width/10,
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //const SizedBox(width: 0.1),
          Text(
            ipList[a],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            date[a].toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // const SizedBox(width: 1,),
        ],
      ),
    );
  }
//ADD END------------------------------------------------------------------------------------------------------

//SHARE START------------------------------------------------------------------------------------------------------
  Widget shareLogs(BuildContext context, List<String> ipList, List<DateTime> date, List<String> attempts){
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.height/2,
          height: (MediaQuery.of(context).size.height/14)*4,
          child: ListView(
            children: [
              for(int a=0;a<attempts.length;a++)
                shareAttempts(context, ipList, date, a),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget shareAttempts(BuildContext context, List<String> ipList, List<DateTime> date, int a, ){
    return Container(
      height: MediaQuery.of(context).size.height/14,
      width: MediaQuery.of(context).size.width/10,
      decoration: BoxDecoration(
        color: Colors.purple,
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //const SizedBox(width: 0.1),
          Text(
            ipList[a],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            date[a].toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // const SizedBox(width: 1,),
        ],
      ),
    );
  }
//SHARE END------------------------------------------------------------------------------------------------------
}