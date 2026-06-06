import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../../schema/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Provider> _searchResults = [];
  bool _isSearching = false;

  // Mock data fokus pada tujuan (Rumah Sakit & Klinik)
  final List<Provider> _allProviders = [
    Provider(
      id: '1',
      name: 'RS Bunda Margonda',
      providerType: 'Hospital',
      address: 'Jl. Margonda Raya No.28',
      city: 'Depok',
      latitude: -6.3712,
      longitude: 106.8324,
      phone: '021-1234567',
      isActive: true,
      createdAt: DateTime.now(),
      h3Index: '',
      distance: '1.2 km',
    ),
    Provider(
      id: '2',
      name: 'RS Universitas Indonesia',
      providerType: 'Hospital',
      address: 'Pondok Cina, Beji',
      city: 'Depok',
      latitude: -6.3654,
      longitude: 106.8288,
      phone: '021-7654321',
      isActive: true,
      createdAt: DateTime.now(),
      h3Index: '',
      distance: '3.5 km',
    ),
    Provider(
      id: '3',
      name: 'Klinik Medika Pratama',
      providerType: 'Clinic',
      address: 'Jl. Akses UI No.45',
      city: 'Depok',
      latitude: -6.3542,
      longitude: 106.8354,
      phone: '021-9988776',
      isActive: true,
      createdAt: DateTime.now(),
      h3Index: '',
      distance: '2.1 km',
    ),
  ];

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = _allProviders
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()) || 
                       p.address.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Cari rumah sakit atau lokasi darurat',
              hintStyle: AppTypography.body.copyWith(fontSize: 14, color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),
      body: _searchController.text.isEmpty
          ? _buildInitialState()
          : _searchResults.isEmpty
              ? _buildEmptyState()
              : _buildSearchResults(),
    );
  }

  Widget _buildInitialState() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pencarian Terakhir', style: AppTypography.title.copyWith(fontSize: 14)),
          const SizedBox(height: 16),
          _buildRecentSearchItem('RS Bunda Margonda'),
          _buildRecentSearchItem('Ambulans Darurat'),
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          const Icon(Icons.history, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Text(text, style: AppTypography.body.copyWith(color: AppColors.textDark)),
          const Spacer(),
          const Icon(Icons.north_west, color: Colors.grey, size: 16),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Layanan tidak ditemukan',
            style: AppTypography.title.copyWith(color: Colors.grey),
          ),
          Text(
            'Coba cari dengan kata kunci lain',
            style: AppTypography.caption.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const Divider(height: 24),
      itemBuilder: (context, index) {
        final provider = _searchResults[index];
        return InkWell(
          onTap: () {
            // Handle selection
          },
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  provider.providerType == 'Hospital' 
                      ? Icons.local_hospital_rounded 
                      : Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: AppTypography.title.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.address,
                      style: AppTypography.caption.copyWith(color: AppColors.textGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                provider.distance,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.amber,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
