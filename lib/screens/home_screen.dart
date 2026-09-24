import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movieit/widgets/layout/custom_footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildBackground(),

          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 140),
                
                GestureDetector(
                  onTap: () {
                    context.push('/movie/123'); 
                  },
                  child: Container(
                    height: 550,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFA970FF), width: 2),
                    ),
                  ),
                ),
                
                const SizedBox(height: 60),
                
                _buildStaticHorizontalList("Trending Now"),
                const SizedBox(height: 15),
                _buildStaticHorizontalList("Popular in Philippines"),
                const SizedBox(height: 15),
                _buildStaticHorizontalList("Upcoming Movies"),
                
                const SizedBox(height: 60),
                const CustomFooter(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStaticHorizontalList(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 220,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }

  Widget _buildBackground() {
    return Container(
      width: double.infinity, height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E0A52), Colors.black, Color(0xFF032D6C)],
        ),
      ),
    );
  }
}