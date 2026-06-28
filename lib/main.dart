import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const MyApp());
}

List<Book> sharedBooks = [];
int totalBorrowed = 0;

class Book {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final String imageUrl;
  int availableCopies;
  final int totalCopies;
  bool isBorrowed;
  final String category;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.imageUrl,
    required this.availableCopies,
    required this.totalCopies,
    this.isBorrowed = false,
    this.category = 'General',
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LibraryMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          surface: const Color(0xFFFFFDF5),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAdmin = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.library_books,
                    size: 80, color: Colors.brown),
                  const SizedBox(height: 16),
                  const Text('LibraryMS',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Library Management System',
                    style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isAdmin = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isAdmin
                                ? Colors.brown
                                : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.brown),
                            ),
                            child: Text('Student',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !isAdmin
                                  ? Colors.white
                                  : Colors.brown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isAdmin = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isAdmin
                                ? Colors.brown
                                : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.brown),
                            ),
                            child: Text('Admin',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isAdmin
                                  ? Colors.white
                                  : Colors.brown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Username or Email',
                      prefixIcon: const Icon(Icons.person,
                        color: Colors.brown),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.brown),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock,
                        color: Colors.brown),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.brown),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isAdmin) {
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) =>
                                const AdminHomeScreen()));
                        } else {
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) =>
                                const StudentHomeScreen()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding:
                          const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isAdmin
                          ? 'Login as Admin'
                          : 'Login as Student',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});
  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  late List<Book> books;
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    if (sharedBooks.isEmpty) {
      sharedBooks = [
        Book(id: '1', title: 'Things Fall Apart',
          author: 'Chinua Achebe',
          isbn: '978-0-385474542',
          imageUrl: '',
          availableCopies: 4, totalCopies: 5,
          category: 'African Literature'),
        Book(id: '2', title: 'Half of a Yellow Sun',
          author: 'Chimamanda Ngozi Adichie',
          isbn: '978-1-400095209',
          imageUrl: '',
          availableCopies: 2, totalCopies: 4,
          category: 'African Literature'),
        Book(id: '3', title: 'Purple Hibiscus',
          author: 'Chimamanda Ngozi Adichie',
          isbn: '978-1-616953072',
          imageUrl: '',
          availableCopies: 3, totalCopies: 3,
          category: 'African Literature'),
        Book(id: '4', title: 'Principles of Economics',
          author: 'N. Gregory Mankiw',
          isbn: '978-0-357038314',
          imageUrl: '',
          availableCopies: 2, totalCopies: 5,
          category: 'Economics'),
        Book(id: '5', title: 'Introduction to Business',
          author: 'Jeff Madura',
          isbn: '978-1-337386494',
          imageUrl: '',
          availableCopies: 1, totalCopies: 3,
          category: 'Business'),
        Book(id: '6', title: 'Business Law',
          author: 'Henry R. Cheeseman',
          isbn: '978-0-134005842',
          imageUrl: '',
          availableCopies: 0, totalCopies: 2,
          category: 'Law'),
        Book(id: '7', title: 'Constitutional Law',
          author: 'Erwin Chemerinsky',
          isbn: '978-1-454873dots',
          imageUrl: '',
          availableCopies: 3, totalCopies: 4,
          category: 'Law'),
        Book(id: '8', title: 'Engineering Mathematics',
          author: 'K.A. Stroud',
          isbn: '978-1-352010268',
          imageUrl: '',
          availableCopies: 2, totalCopies: 4,
          category: 'Engineering'),
        Book(id: '9', title: 'Fundamentals of Physics',
          author: 'David Halliday',
          isbn: '978-1-118230718',
          imageUrl: '',
          availableCopies: 1, totalCopies: 3,
          category: 'Engineering'),
        Book(id: '10', title: 'Clean Code',
          author: 'Robert C. Martin',
          isbn: '978-0-132350884',
          imageUrl: '',
          availableCopies: 3, totalCopies: 5,
          category: 'Computer Science'),
        Book(id: '11', title: 'Introduction to Algorithms',
          author: 'Thomas H. Cormen',
          isbn: '978-0-262033848',
          imageUrl: '',
          availableCopies: 0, totalCopies: 3,
          category: 'Computer Science'),
        Book(id: '12', title: 'The Anatomy of Peace',
          author: 'Arbinger Institute',
          isbn: '978-1-626564718',
          imageUrl: '',
          availableCopies: 2, totalCopies: 3,
          category: 'Philosophy'),
      ];
    }
    books = sharedBooks;
  }

  void _showQRScanner(BuildContext context) {
  final MobileScannerController cameraController =
    MobileScannerController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Scan Book QR Code',
        style: TextStyle(color: Colors.brown)),
      content: SizedBox(
        width: 300,
        height: 300,
        child: MobileScanner(
          controller: cameraController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              final code = barcode.rawValue ?? '';
              final bookId =
                code.replaceAll('BOOK-', '').split('-')[0];
              final matchingBooks = books
                .where((b) =>
                  b.id == bookId && b.availableCopies > 0)
                .toList();
              if (matchingBooks.isNotEmpty) {
                final book = matchingBooks.first;
                setState(() {
                  book.availableCopies--;
                  book.isBorrowed = true;
                  totalBorrowed++;
                });
                cameraController.dispose();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Successfully borrowed "${book.title}"'),
                    backgroundColor: Colors.green),
                );
              }
            }
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            cameraController.dispose();
            Navigator.pop(context);
          },
          child: const Text('Cancel',
            style: TextStyle(color: Colors.grey)),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final categories =
      ['All', ...sharedBooks.map((b) => b.category).toSet()];
    final displayedBooks = selectedCategory == 'All'
      ? books
      : books
        .where((b) => b.category == selectedCategory)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      appBar: AppBar(
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Available Books',
          style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => _showQRScanner(context),
            tooltip: 'Scan QR to Borrow',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat,
                      style: TextStyle(
                        color: isSelected
                          ? Colors.white
                          : Colors.brown,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.brown,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategory = cat;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: displayedBooks.length,
              itemBuilder: (context, index) {
                final book = displayedBooks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.brown.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.book,
                            color: Colors.brown, size: 30),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                              CrossAxisAlignment.start,
                            children: [
                              Text(book.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                              Text(book.author,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13)),
                              const SizedBox(height: 4),
                              Chip(
                                label: Text(book.category,
                                  style: const TextStyle(
                                    fontSize: 10)),
                                padding: EdgeInsets.zero,
                                visualDensity:
                                  VisualDensity.compact,
                                backgroundColor:
                                  Colors.brown.shade50,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Available: ${book.availableCopies}/${book.totalCopies}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: book.availableCopies > 0
                                        ? Colors.green
                                        : Colors.red,
                                    ),
                                  ),
                                  Container(
                                    padding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: book.availableCopies > 0
                                        ? Colors.green.shade50
                                        : Colors.red.shade50,
                                      borderRadius:
                                        BorderRadius.circular(4),
                                      border: Border.all(
                                        color: book.availableCopies > 0
                                          ? Colors.green
                                          : Colors.red,
                                      ),
                                    ),
                                    child: Text(
                                      book.availableCopies > 0
                                        ? 'Available'
                                        : 'Unavailable',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: book.availableCopies > 0
                                          ? Colors.green
                                          : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Use QR scanner to borrow',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQRScanner(context),
        backgroundColor: Colors.brown,
        icon: const Icon(Icons.qr_code_scanner,
          color: Colors.white),
        label: const Text('Scan to Borrow',
          style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final List<Map<String, dynamic>> studentsList = [
    {'name': 'Amara Okafor', 'username': 'amara.o',
      'borrowedCount': 2, 'status': 'Active'},
    {'name': 'Blessing Okon', 'username': 'blessing.o',
      'borrowedCount': 0, 'status': 'Active'},
    {'name': 'Amos Yusuf', 'username': 'amos.y',
      'borrowedCount': 3, 'status': 'Pending Fine'},
    {'name': 'Fatima Musa', 'username': 'fatima.m',
      'borrowedCount': 1, 'status': 'Active'},
    {'name': 'Chidi Eze', 'username': 'chidi.e',
      'borrowedCount': 0, 'status': 'Active'},
  ];

  void _showGenerateQR(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('QR Code — ${book.title}',
          style: const TextStyle(
            color: Colors.brown, fontSize: 15)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: QrImageView(
                  data: 'BOOK-${book.id}',
                  version: QrVersions.auto,
                  size: 200,
                ),
              ),
              const SizedBox(height: 8),
              Text(book.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
              Text('Author: ${book.author}',
                style: const TextStyle(
                  color: Colors.grey, fontSize: 12)),
              Text('ISBN: ${book.isbn}',
                style: const TextStyle(
                  color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Scan Code: BOOK-${book.id}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
              style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Press Ctrl+P or use browser menu to print'),
                  backgroundColor: Colors.brown,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            icon: const Icon(Icons.print, color: Colors.white),
            label: const Text('Print QR',
              style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown),
          ),
        ],
      ),
    );
  }

  void _showStudentDetails(
      BuildContext context, Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${student['name']}\'s Profile',
          style: const TextStyle(color: Colors.brown)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.brown,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                    Text('@${student['username']}',
                      style: const TextStyle(
                        color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Account Status:'),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: student['status'] == 'Active'
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: student['status'] == 'Active'
                        ? Colors.green
                        : Colors.red),
                  ),
                  child: Text(student['status'],
                    style: TextStyle(
                      color: student['status'] == 'Active'
                        ? Colors.green
                        : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Books Borrowed:'),
                Text('${student['borrowedCount']} items',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
              style: TextStyle(color: Colors.brown))),
        ],
      ),
    );
  }

  void _showAddBook(BuildContext context) {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final isbnController = TextEditingController();
    final copiesController = TextEditingController();
    String selectedCat = 'General';
    final categories = [
      'General', 'African Literature', 'Computer Science',
      'Economics', 'Business', 'Law', 'Engineering',
      'Philosophy', 'Medicine', 'Education'
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Book',
            style: TextStyle(color: Colors.brown)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Book Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: authorController,
                  decoration: InputDecoration(
                    labelText: 'Author',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: isbnController,
                  decoration: InputDecoration(
                    labelText: 'ISBN',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: copiesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Number of Copies',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCat,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  ),
                  items: categories.map((cat) =>
                    DropdownMenuItem(
                      value: cat,
                      child: Text(cat))).toList(),
                  onChanged: (val) {
                    setDialogState(() {
                      selectedCat = val!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  sharedBooks.add(Book(
                    id: '${sharedBooks.length + 1}',
                    title: titleController.text,
                    author: authorController.text,
                    isbn: isbnController.text,
                    imageUrl: '',
                    availableCopies:
                      int.tryParse(copiesController.text) ?? 1,
                    totalCopies:
                      int.tryParse(copiesController.text) ?? 1,
                    category: selectedCat,
                  ));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Book added successfully!'),
                      backgroundColor: Colors.green),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown),
              child: const Text('Add Book',
                style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final borrowedBooks =
      sharedBooks.where((b) => b.isBorrowed).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      appBar: AppBar(
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Admin Dashboard',
          style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('System Analytics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildMetricCard(
                  'Total Books',
                  '${sharedBooks.length}',
                  Colors.brown,
                  Icons.book)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricCard(
                  'Borrowed',
                  '$totalBorrowed',
                  Colors.orange,
                  Icons.swap_horiz)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildMetricCard(
                  'Students',
                  '${studentsList.length}',
                  Colors.teal,
                  Icons.people)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricCard(
                  'Available',
                  '${sharedBooks.where((b) => b.availableCopies > 0).length}',
                  Colors.green,
                  Icons.check_circle)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Quick Actions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.brown)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddBook(context),
                    icon: const Icon(Icons.add,
                      color: Colors.white),
                    label: const Text('Add Book',
                      style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Book List & QR Codes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.brown)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sharedBooks.length,
              itemBuilder: (context, index) {
                final book = sharedBooks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.brown.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.book,
                        color: Colors.brown, size: 24),
                    ),
                    title: Text(book.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                    subtitle: Text(
                      '${book.author}\nAvailable: ${book.availableCopies}/${book.totalCopies}',
                      style: const TextStyle(fontSize: 11)),
                    isThreeLine: true,
                    trailing: ElevatedButton.icon(
                      onPressed: () =>
                        _showGenerateQR(context, book),
                      icon: const Icon(Icons.qr_code,
                        color: Colors.white, size: 14),
                      label: const Text('QR',
                        style: TextStyle(
                          color: Colors.white, fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4)),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('Borrowed Books Log',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.brown)),
            const SizedBox(height: 8),
            borrowedBooks.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('No books borrowed yet',
                      style: TextStyle(color: Colors.grey)),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: borrowedBooks.length,
                  itemBuilder: (context, index) {
                    final book = borrowedBooks[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.book,
                          color: Colors.brown),
                        title: Text(book.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                        subtitle: Text(book.author,
                          style: const TextStyle(fontSize: 11)),
                        trailing: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              book.isBorrowed = false;
                              book.availableCopies++;
                              if (totalBorrowed > 0) {
                                totalBorrowed--;
                              }
                            });
                            ScaffoldMessenger.of(context)
                              .showSnackBar(
                              SnackBar(
                                content: Text(
                                  '"${book.title}" returned!'),
                                backgroundColor: Colors.green),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4)),
                          child: const Text('Return',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12)),
                        ),
                      ),
                    );
                  },
                ),
            const SizedBox(height: 24),
            const Text('Student Directory',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.brown)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: studentsList.length,
              itemBuilder: (context, index) {
                final student = studentsList[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.brown,
                      child: Icon(Icons.person,
                        color: Colors.white)),
                    title: Text(student['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      '@${student['username']} • ${student['status']}'),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14, color: Colors.brown),
                    onTap: () =>
                      _showStudentDetails(context, student),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
      String label, String value, Color color, IconData icon) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 4),
            Text(value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
            Text(label,
              style: const TextStyle(
                color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}