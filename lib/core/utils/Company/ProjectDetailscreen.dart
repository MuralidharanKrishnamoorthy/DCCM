import 'package:dccm/Colors.dart';
import 'package:dccm/core/utils/Company/CompanyNavigation.dart';
import 'package:dccm/core/utils/Company/Payments.dart';
import 'package:dccm/customappbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ProjectDetailScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailScreen({Key? key, required this.projectId})
      : super(key: key);

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late Future<Map<String, dynamic>> _projectFuture;
  static const String baseUrl = 'http://192.168.122.19:8080/api/dccm';
  final ScrollController _scrollController = ScrollController();
  final currencyFormatter =
      NumberFormat.currency(locale: 'en_US', symbol: '\$');
  int _selectedSegment = 0;

  static const Color kPrimaryColor = Color(0xFF1C1C1E);
  static const Color kAccentColor = Color(0xFFD4AF37);
  static const Color kBackgroundColor = CupertinoColors.systemBackground;
  static const Color kTextColor = CupertinoColors.label;
  static const Color kSecondaryTextColor = CupertinoColors.secondaryLabel;

  @override
  void initState() {
    super.initState();
    _projectFuture = _fetchProjectDetails();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchProjectDetails() async {
    final response =
        await http.get(Uri.parse('$baseUrl/project/${widget.projectId}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load project details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: kParchment,
        navigationBar: CustomAppbar(
          leading: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CompanyNavigation()),
            ),
            child: CircleAvatar(
              backgroundColor: AppTheme.getTertiaryIconColor(context),
              child: Icon(
                CupertinoIcons.back,
                color: AppTheme.getAppBarForegroundColor(context),
                size: 20, // Adjust size as needed
              ),
            ),
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _projectFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CupertinoActivityIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error}',
                        style: TextStyle(color: kTextColor)));
              } else if (!snapshot.hasData) {
                return Center(
                    child: Text('No data available',
                        style: TextStyle(color: kTextColor)));
              }

              var project = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _buildHeader(project),
                          _buildSegmentedControl(),
                          _buildSelectedSection(project),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomBar(project),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> project) {
    return _buildSectionCard(
      'Project Overview',
      [
        _buildInfoRow('DCCM', project['projectDetail']?.toString() ?? 'N/A'),
        _buildInfoRow('Survey ID', project['surveyId']?.toString() ?? 'N/A'),
      ],
      icon: CupertinoIcons.doc_text,
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: CupertinoSlidingSegmentedControl<int>(
        children: const {
          0: Text('Details'),
          1: Text('Location'),
          2: Text('Contact'),
        },
        onValueChanged: (int? value) {
          if (value != null) {
            setState(() {
              _selectedSegment = value;
            });
          }
        },
        groupValue: _selectedSegment,
        backgroundColor: kBackgroundColor,
        thumbColor: kAccentColor,
      ),
    );
  }

  Widget _buildSelectedSection(Map<String, dynamic> project) {
    switch (_selectedSegment) {
      case 0:
        return _buildDetailsSection(project);
      case 1:
        return _buildLocationSection(project);
      case 2:
        return _buildContactSection(project);
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildSectionCard(String title, List<Widget> children,
      {IconData? icon}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBackgroundColor,
        border: Border(
          bottom: BorderSide(color: kAccentColor.withOpacity(0.3), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) Icon(icon, color: kAccentColor, size: 24),
              if (icon != null) const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                    color: kTextColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailsSection(Map<String, dynamic> project) {
    return Column(
      children: [
        _buildSectionCard(
          'Tree Information',
          [
            _buildInfoRow(
                'Land Size', project['landSize']?.toString() ?? 'N/A'),
            _buildInfoRow('Tree Age', project['treeAge']?.toString() ?? 'N/A'),
            _buildInfoRow(
                'Tree Species', project['treeSpecies']?.toString() ?? 'N/A'),
          ],
          icon: CupertinoIcons.tree,
        ),
        _buildSectionCard(
          'Carbon Credits',
          [
            Text(
              'By purchasing this project, you will reduce:',
              style: TextStyle(color: kTextColor, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              '${project['creditPoints']?.toString() ?? '0'} Tons of CO2',
              style: TextStyle(
                  color: kAccentColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'from the environment',
              style: TextStyle(color: kTextColor, fontSize: 18),
            ),
          ],
          icon: CupertinoIcons.leaf_arrow_circlepath,
        ),
      ],
    );
  }

  Widget _buildLocationSection(Map<String, dynamic> project) {
    return _buildSectionCard(
      'Location',
      [
        _buildInfoRow('Country', project['country']?.toString() ?? 'N/A'),
        _buildInfoRow('State', project['state']?.toString() ?? 'N/A'),
        _buildInfoRow('Pincode', project['pincode']?.toString() ?? 'N/A'),
        _buildInfoRow('Landmark', project['landmark']?.toString() ?? 'N/A'),
      ],
      icon: CupertinoIcons.location,
    );
  }

  Widget _buildContactSection(Map<String, dynamic> project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionCard(
          'Contact Information',
          [
            _buildInfoRow(
                'Landowner', project['landownername']?.toString() ?? 'N/A'),
            _buildInfoRow('Email', project['email']?.toString() ?? 'N/A'),
            _buildInfoRow(
                'Phone', project['issuerId']?.toString() ?? 'Not provided'),
          ],
          icon: CupertinoIcons.person,
        ),
        _buildSectionCard(
          'Additional Information',
          [
            _buildCopyableInfoRow(
                'Metamask ID', project['metamaskid']?.toString() ?? 'N/A'),
          ],
          icon: CupertinoIcons.info_circle,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: kSecondaryTextColor, fontSize: 16)),
          Text(
            value,
            style: TextStyle(
                color: kTextColor, fontSize: 18, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: kSecondaryTextColor, fontSize: 16)),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              _showCopiedToast(context);
            },
            child: Row(
              children: [
                Text(value,
                    style: TextStyle(
                        color: kTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Icon(CupertinoIcons.doc_on_doc, size: 18, color: kAccentColor)
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCopiedToast(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title:
            Text('Copied to clipboard', style: TextStyle(color: kPrimaryColor)),
        actions: [
          CupertinoActionSheetAction(
            child: Text('OK', style: TextStyle(color: kPrimaryColor)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(Map<String, dynamic> project) {
    String formattedPrice = 'N/A';
    if (project['finalPrice'] != null) {
      formattedPrice = currencyFormatter.format(project['finalPrice']);
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Price',
                    style: TextStyle(color: kSecondaryTextColor, fontSize: 18)),
                Text(formattedPrice,
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            CupertinoButton(
              color: kAccentColor,
              borderRadius: BorderRadius.circular(3),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Text('Buy Now',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => PaymentScreen(
                      project: {
                        'projectDetail': project['projectDetail'],
                        'metamaskid': project['metamaskid'],
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
