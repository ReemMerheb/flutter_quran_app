import 'package:flutter/material.dart';
import 'package:quran_app/screens/surah.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Text(
              'Quran App',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 102, 47, 112),
              ),
            ),
            const SizedBox(height: 10), 
            Text(
              'Learn Quran and \n recite once everyday ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30), 
            
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none, 
              children: [
                
                ClipRRect(
                  borderRadius: BorderRadius.circular(20), 
                  child: Image.asset(
                    'assets/Frame1.png', 
                    width: 330,
                    height: 490,
                    fit: BoxFit.cover,
                  ),
                ),
                
                Positioned(
                  bottom: -25, 
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurahPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(244, 169, 112, 1),
                      foregroundColor: Colors.white, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10), 
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
