// lib/home_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_page.dart'; // <-- ADD THIS IMPORT

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Get current user safely
  User? get user => Supabase.instance.client.auth.currentUser;

  // FIXED: Profile tab now opens real page
  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 4) {
      // Profile tab
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    } else if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Explore Page Coming Soon")),
      );
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("My Bookings")),
      );
    } else if (index == 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inbox")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D), appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 120, // Gives enough space
      title: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting – smaller but bold and clear
            Text(
              "Morning, ${user?.userMetadata?['full_name']?.split(' ').first ?? user?.email?.split('@').first ?? 'Guest'}!",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              "Book your favorite salon today!",
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),

            // Search bar inside AppBar (optional but recommended

          ],
        ),
      ),
      actions: const [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: Colors.white, size: 26),
          onPressed: null,
        ),
        IconButton(
          icon: Icon(Icons.bookmark_border, color: Colors.white, size: 26),
          onPressed: null,
        ),
        SizedBox(width: 12),
      ],
    ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting with real name


            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search salon, service...",
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 32),

            // Today's Special Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFFF8B00), Color(0xFFFF6B00)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("30% OFF",
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.white70)),
                      Text("Today's Special",
                          style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 8),
                      Text("Get discount on every service!",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.white70)),
                      Text("Valid only today",
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.white60)),
                    ],
                  ),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "30%",
                        style: GoogleFonts.poppins(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Most Popular Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Most Popular",
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                TextButton(
                  onPressed: () {},
                  child: Text("See All",
                      style: GoogleFonts.poppins(color: Colors.orange)),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _categoryChip("All", isSelected: true),
                  _categoryChip("Haircuts"),
                  _categoryChip("Make up"),
                  _categoryChip("Manicure"),
                  _categoryChip("Massage"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Popular Salons
            _salonCard(
              name: "Hair Force",
              address: "813 Village Drive",
              distance: "3.4 km",
              rating: 4.6,
              imageUrl: "https://images.unsplash.com/photo-1595476108010-b4d1f102b1b1?w=400",
            ),
            const SizedBox(height: 16),
            _salonCard(
              name: "Serenity Salon",
              address: "88 Commercial Plaza",
              distance: "4.2 km",
              rating: 4.0,
              imageUrl: "https://images.unsplash.com/photo-1559598467-f8b76c5e1d0f?w=400",
            ),
            const SizedBox(height: 16),
            _salonCard(
              name: "The Razor's Edge",
              address: "54 Artisan Avenue",
              distance: "4.5 km",
              rating: 4.6,
              imageUrl: "https://images.unsplash.com/photo-1521590832167-8d6d5c9e59e7?w=400",
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // Beautiful Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.white54,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "My Booking"),
            BottomNavigationBarItem(icon: Icon(Icons.inbox), label: "Inbox"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }

  // Category Chip
  Widget _categoryChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ChoiceChip(
        label: Text(label,
            style: GoogleFonts.poppins(
                color: isSelected ? Colors.white : Colors.orange)),
        selected: isSelected,
        selectedColor: Colors.orange,
        backgroundColor: Colors.white.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onSelected: (_) {},
      ),
    );
  }

  // Salon Card
  Widget _salonCard({
    required String name,
    required String address,
    required String distance,
    required double rating,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey,
                child: const Icon(Icons.spa, color: Colors.white54, size: 40),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text(address,
                    style: const TextStyle(color: Colors.white60, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.orange),
                    Text(" $distance",
                        style: const TextStyle(color: Colors.orange, fontSize: 13)),
                    const Spacer(),
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text("$rating",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white60),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}