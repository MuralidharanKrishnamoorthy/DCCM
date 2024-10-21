import 'package:dccm/Colors.dart';
import 'package:dccm/core/utils/Company/CompanyNavigation.dart';
import 'package:dccm/customappbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? project;

  const PaymentScreen({super.key, this.project});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  bool _isMetaMaskConnected = false;
  String _transactionStatus = '';
  late WalletConnect connector;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _amountController = TextEditingController();

  String get projectName =>
      widget.project?['projectDetail'] ?? 'Unknown Project';
  String get projectMetaMaskId =>
      widget.project?['metamaskid'] ?? 'No MetaMask ID';

  @override
  void initState() {
    super.initState();

    _initializeWalletConnect();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _initializeWalletConnect() async {
    connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'DCCM App',
        description: 'DCCM Payment Application',
        url: 'https://dccm.com',
        icons: ['https://dccm.com/app-icon.png'],
      ),
    );

    connector.on(
        'connect',
        (session) => setState(() {
              _isMetaMaskConnected = true;
              _animationController.forward();
            }));

    connector.on('session_update', (payload) => print(payload));
    connector.on(
        'disconnect',
        (session) => setState(() {
              _isMetaMaskConnected = false;
              _animationController.reverse();
            }));
  }

  Future<void> _connectMetaMask() async {
    if (!connector.connected) {
      try {
        final session =
            await connector.createSession(onDisplayUri: (uri) async {
          await _launchMetaMask(uri);
        });
        debugPrint("Session created: ${session.accounts[0]}");
        setState(() {
          _isMetaMaskConnected = true;
        });
      } catch (e) {
        debugPrint("Error creating session: $e");
        _showAlert('Connection Error',
            'Failed to connect to MetaMask. Please try again.');
      }
    } else {
      await connector.killSession();
      setState(() {
        _isMetaMaskConnected = false;
      });
    }
  }

  Future<void> _launchMetaMask(String uri) async {
    final encodedUri = Uri.encodeComponent(uri);
    final deepLink = 'metamask://wc?uri=$encodedUri';
    final universalLink = 'https://metamask.app.link/wc?uri=$encodedUri';

    try {
      // First, try to launch the deep link
      if (await canLaunchUrl(Uri.parse(deepLink))) {
        await launchUrl(Uri.parse(deepLink),
            mode: LaunchMode.externalApplication);
      }
      // If deep link fails, try the universal link
      else if (await canLaunchUrl(Uri.parse(universalLink))) {
        await launchUrl(Uri.parse(universalLink),
            mode: LaunchMode.externalApplication);
      }
      // If both fail, open the MetaMask website
      else {
        await launchUrl(Uri.parse('https://metamask.io/download.html'),
            mode: LaunchMode.externalApplication);
        _showAlert('MetaMask Not Found',
            'Please ensure MetaMask is installed and properly set up, then try again.');
      }
    } catch (e) {
      debugPrint("Error launching MetaMask: $e");
      _showAlert('Launch Error',
          'Failed to open MetaMask. Please ensure it\'s installed and try again.');
    }
  }

  Future<void> _transferTokens() async {
    if (!_isMetaMaskConnected) {
      _showAlert('Connect MetaMask',
          'Please connect MetaMask before making a transfer.');
      return;
    }

    if (_amountController.text.isEmpty) {
      _showAlert(
          'Enter Amount', 'Please enter the amount of tokens to transfer.');
      return;
    }

    setState(() {
      _transactionStatus = 'Initiating transaction...';
    });

    try {
      // Implement your token transfer logic here
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _transactionStatus = 'Transaction successful!';
      });

      _showAlert('Payment Completed', 'Your token transfer was successful.');
    } catch (e) {
      setState(() {
        _transactionStatus = 'Error: $e';
      });
      _showAlert(
          'Transaction Failed', 'An error occurred during the transfer.');
    }
  }

  void _showAlert(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
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
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),
                      _buildProjectCard(),
                      const SizedBox(height: 30),
                      _buildMetaMaskConnection(),
                      const SizedBox(height: 30),
                      _buildAmountInput(),
                      const SizedBox(height: 30),
                      _buildTransferSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF34C759), Color(0xFF30D158)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF30D158).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          projectName.isNotEmpty
                              ? projectName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF34C759),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        projectName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'MetaMask ID',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  projectMetaMaskId,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaMaskConnection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'METAMASK CONNECTION',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: CupertinoColors.systemGrey5,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.network(
                          'https://raw.githubusercontent.com/MetaMask/brand-resources/master/SVG/metamask-fox.svg',
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _isMetaMaskConnected ? 'Connected' : 'Not Connected',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _isMetaMaskConnected
                                ? CupertinoColors.activeGreen
                                : CupertinoColors.systemGrey,
                          ),
                        ),
                      ],
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      color: _isMetaMaskConnected
                          ? CupertinoColors.systemRed
                          : CupertinoColors.activeBlue,
                      borderRadius: BorderRadius.circular(20),
                      onPressed: _connectMetaMask,
                      child: Text(
                        _isMetaMaskConnected ? 'Disconnect' : 'Connect',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AMOUNT TO TRANSFER',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: CupertinoColors.systemGrey5,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: CupertinoTextField(
            controller: _amountController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            placeholder: 'Enter amount',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransferSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 + (_animation.value * 0.05),
              child: CupertinoButton(
                onPressed: _isMetaMaskConnected ? _transferTokens : null,
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: CupertinoColors.activeBlue,
                borderRadius: BorderRadius.circular(16),
                child: const Text(
                  'Transfer Tokens',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        AnimatedOpacity(
          opacity: _transactionStatus.isNotEmpty ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            _transactionStatus,
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemBlue,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
