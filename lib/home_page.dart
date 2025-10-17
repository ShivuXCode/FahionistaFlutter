import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All';
  String sortBy = 'None';

  final List<Map<String, dynamic>> allProducts = [
    {
      'name': 'black Shirt',
      'price': 799.0,
      'image':
          'https://www.beyours.in/cdn/shop/files/black-classic-shirt.jpg?v=1744815740',
      'category': 'Mens',
    },
    {
      'name': 'grey shirt',
      'price': 799.0,
      'image':
          'https://5.imimg.com/data5/BA/SC/MY-5527997/steel-grey-trousers.jpg',
      'category': 'Mens',
    },
    {
      'name': 'Floral Dress',
      'price': 1299.0,
      'image':
          'https://peachmode.com/cdn/shop/files/1_RAJT-7241-CREAM-PEACHMODE.jpg?v=1697630221',
      'category': 'Womens',
    },
    {
      'name': 'Kids Frock',
      'price': 499.0,
      'image':
          'https://www.labelkanupriya.com/cdn/shop/files/1721886180081.jpg?v=1721892632&width=3000',
      'category': 'Childrens',
    },
    {
      'name': 'Kids Shirt',
      'price': 499.0,
      'image':
          'https://www.mumkins.in/cdn/shop/products/601e27d227258.jpg?v=1757574845',
      'category': 'Childrens',
    },
    {
      'name': 'Women’s Handbag',
      'price': 1499.0,
      'image':
          'https://assets.ajio.com/medias/sys_master/root/20250420/Bqda/6805211e55340d4b4feb58a6/-1117Wx1400H-701477578-olive-MODEL.jpg',
      'category': 'Accessories',
    },
    {
      'name': 'Men’s Shoes',
      'price': 1999.0,
      'image':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
      'category': 'Mens',
    },
    {
      'name': 'Women’s Sandals',
      'price': 999.0,
      'image':
          'https://paragonfootwear.com/cdn/shop/files/Lifestyle_dbd14087-e73a-4df4-a44d-d6b5afbaf1b3.jpg?v=1757493090&width=1920',
      'category': 'Womens',
    },
    {
      'name': 'Mens Watch',
      'price': 999.0,
      'image':
          'https://cdn.shopify.com/s/files/1/0571/6223/6113/files/Starboard_10x500_96c1757e-e0c2-48dc-8b19-fbe0f3b3aa2f_1024x1024.webp?v=1726908513',
      'category': 'Accessories',
    },
    {
      'name': 'Mens Bracelet',
      'price': 999.0,
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFhgkO1vreXWNBdWGFpfkcpA4urc_LZJV8Bw&s',
      'category': 'Accessories',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    List<Map<String, dynamic>> displayedProducts = List.from(allProducts);

    // --- Category Filter ---
    if (selectedCategory != 'All') {
      displayedProducts = displayedProducts
          .where((p) => p['category'] == selectedCategory)
          .toList();
    }

    // --- Sorting Logic ---
    if (sortBy == 'Price: Low to High') {
      displayedProducts.sort((a, b) => a['price'].compareTo(b['price']));
    } else if (sortBy == 'Price: High to Low') {
      displayedProducts.sort((a, b) => b['price'].compareTo(a['price']));
    } else if (sortBy == 'Alphabetical') {
      displayedProducts.sort(
          (a, b) => a['name'].toString().compareTo(b['name'].toString()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fashionista'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      cart.items.length.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 10),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildFilters(context),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: displayedProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final product = displayedProducts[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15)),
                          child: GestureDetector(
                            onTap: () {
                              // show enlarged modal
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  insetPadding: const EdgeInsets.all(16),
                                  child: InteractiveViewer(
                                    clipBehavior: Clip.none,
                                    minScale: 0.8,
                                    maxScale: 4.0,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            product['image'],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: IconButton(
                                            icon: const Icon(Icons.close,
                                                color: Colors.white, size: 28),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: product['image'],
                              child: Image.network(
                                product['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['name'],
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('₹${product['price']}',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pinkAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () {
                                cart.addItem(CartItem(
                                    name: product['name'],
                                    price: product['price'],
                                    imageUrl: product['image']));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          '${product['name']} added to cart')),
                                );
                              },
                              child: const Text('Add to Cart'),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Filter and Sort Bar ---
  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            value: selectedCategory,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            items: ['All', 'Mens', 'Womens', 'Childrens', 'Accessories']
                .map((cat) => DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
              });
            },
          ),
          DropdownButton<String>(
            value: sortBy,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            items: [
              'None',
              'Price: Low to High',
              'Price: High to Low',
              'Alphabetical'
            ].map((s) => DropdownMenuItem<String>(
                  value: s,
                  child: Text(s),
                ))
            .toList(),
            onChanged: (value) {
              setState(() {
                sortBy = value!;
              });
            },
          ),
        ],
      ),
    );
  }
}
