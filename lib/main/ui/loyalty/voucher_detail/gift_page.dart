import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/notify/notify_model.dart';
import 'package:cam_id/main/utils/utility_fuctions.dart';
import 'package:cam_id/main/utils/widget/common_widgets.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/res/app_styles.dart';
import 'package:cam_id/router.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'gift_bloc.dart';

class VoucherDetailPage extends StatefulWidget {
  const VoucherDetailPage({super.key});

  @override
  State<VoucherDetailPage> createState() => _VoucherDetailPageState();
}

class _VoucherDetailPageState extends State<VoucherDetailPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => GiftBloc()
        ..add(LoadNewsNotifications())
        ..add(LoadComplainNotifications()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0, // ngăn elevation khi cuộn dưới
          surfaceTintColor: Colors.transparent, // ngăn tint màu khi cuộn
          leading: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    AppImages.icBackBlack,
                    // width: 24,
                    // height: 24,
                  ),
                ),
              ),
            ),
          ),

          title: Text(l10n.history, style: AppStyles.header),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                AppImages.icSearchBlack,
                width: 24,
                height: 24,
              ),
              onPressed: () {
                final feedbackBloc = context.read<GiftBloc>();

                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    // Cung cấp Bloc cho context của Dialog
                    return BlocProvider.value(
                      value: feedbackBloc,
                      child: Dialog(
                        backgroundColor: Colors.transparent,
                        // BlocBuilder phải nằm ở ĐÂY để lắng nghe thay đổi khi đang mở Dialog
                        child: BlocBuilder<GiftBloc, GiftState>(
                          builder: (context, state) {
                            return _buildFilterDialog(context, state);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(width: 16),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(child: CouponCardWithNotches()),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: commonButton(text: l10n.loyaltyRedeem, onPressed: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyNoti(l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImages.imgEmptyNoti),
          Text(
            l10n.noNotiTitle,
            style: AppStyles.poppins12Regular.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildFilterDialog(BuildContext context, GiftState state) {
    final bloc = context.read<GiftBloc>();
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize
            .min, // Quan trọng: Để popup không chiếm hết chiều cao màn hình
        children: [
          // 2. Tiêu đề
          Center(
            child: Text(
              l10n.selectDateRange,
              style: AppTextFonts.poppinsSemiBold.copyWith(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          // chon ngay thang
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.from,
                      style: AppStyles.poppins12Regular.copyWith(
                        fontSize: 16,
                        color: AppColors.color_8588,
                      ),
                    ),
                    datePickerField(
                      context: context,
                      selectedDate: DateTime.now(),
                      onDateSelected: (newDate) {
                        //  bloc.add(DateFilterChanged(newDate, "from"));
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.to,
                      style: AppStyles.poppins12Regular.copyWith(
                        fontSize: 16,
                        color: AppColors.color_8588,
                      ),
                    ),
                    datePickerField(
                      context: context,
                      selectedDate: DateTime.now(),
                      onDateSelected: (newDate) {
                        //    bloc.add(DateFilterChanged(newDate, "to"));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          // chon service type
          Text(
            l10n.serviceType,
            style: AppStyles.poppins12Regular.copyWith(
              fontSize: 16,
              color: AppColors.color_8588,
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildFilterItem(false, l10n.today, "value", () {}),
                  ),
                  Expanded(
                    child: _buildFilterItem(
                      false,
                      l10n.thisMonth,
                      "value",
                      () {},
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildFilterItem(
                      false,
                      l10n.thisWeek,
                      "value",
                      () {},
                    ),
                  ),
                  Expanded(
                    child: _buildFilterItem(
                      false,
                      l10n.thisYear,
                      "value",
                      () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 4. Các nút bấm hành động
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: commonButton(
                  text: l10n.cancel,
                  color: AppColors.color_5F5F,
                  textColor: AppColors.color_0000,
                  onPressed: () => context.pop(),
                ),
              ),
              Expanded(
                child: commonButton(
                  text: l10n.search,
                  onPressed: () {
                    //     bloc.add(ChangeAcc());
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(
    bool isSelected,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            isSelected ? AppImages.icRadioBtnTicked : AppImages.icRadioBtn,
          ),
          Text(
            label,
            style: AppStyles.poppins12Regular.copyWith(
              fontSize: 16,
              color: AppColors.color_8588,
            ),
          ),
        ],
      ),
    );
  }
}

class TopPartClipper extends CustomClipper<Path> {
  final double notchRadius; // Bán kính của vết lõm
  final double notchOffset; // Khoảng cách từ trên/dưới đến tâm vết lõm

  TopPartClipper({this.notchRadius = 15.0, this.notchOffset = 20.0});

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height); // Bắt đầu từ dưới trái đi lên
    path.lineTo(size.width, size.height); // Đi ngang qua dưới cùng
    path.lineTo(
      size.width,
      notchOffset + notchRadius,
    ); // Đi lên tới vị trí vết lõm bên phải

    // Vẽ cung lõm bên phải
    path.arcToPoint(
      Offset(size.width, notchOffset - notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: true, // Lõm vào
    );

    path.lineTo(size.width, 0); // Đi thẳng lên đỉnh phải
    path.lineTo(0, 0); // Đi ngang qua đỉnh trái

    path.lineTo(
      0,
      notchOffset + notchRadius,
    ); // Đi lên tới vị trí vết lõm bên trai
    // Vẽ cung lõm bên trái
    path.arcToPoint(
      Offset(0, notchOffset - notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: true, // Lõm vào
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double gapWidth;

  DashedLinePainter({
    this.color = Colors.grey,
    this.strokeWidth = 2.0,
    this.dashWidth = 5.0,
    this.gapWidth = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + gapWidth;
    }
  }

  @override
  bool shouldRepaint(covariant DashedLinePainter oldDelegate) => false;
}

class BottomNotchClipper extends CustomClipper<Path> {
  final double notchRadius; // Bán kính mỗi vết lõm
  final double startOffset; // Khoảng cách từ mép trái đến vết lõm đầu tiên
  final double endOffset; // Khoảng cách từ mép phải đến vết lõm cuối cùng

  BottomNotchClipper({
    this.notchRadius = 10.0,
    this.startOffset = 20.0,
    this.endOffset = 20.0,
  });

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height); // Đi từ trên trái xuống dưới trái

    // Vẽ hàng bán nguyệt lõm ở cạnh đáy
    double currentX = 0;
    while (currentX < size.width) {
      // Bắt đầu 1 nửa hình tròn (đi lên)
      path.relativeArcToPoint(
        Offset(notchRadius * 2, 0),
        radius: Radius.circular(notchRadius),
        clockwise: false, // Lõm vào
      );
      currentX += notchRadius * 2;
    }

    path.lineTo(size.width, 0); // Đi từ dưới phải lên trên phải
    path.close(); // Đóng path

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// Ví dụ về sử dụng trong Widget Build
class CouponCardWithNotches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      child: ClipPath(
        // Bọc cả thẻ bằng ClipPath chung
        clipper: TopPartClipper(
          notchRadius: 15,
          notchOffset: 60,
        ), // Notch cho phần trên
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Đảm bảo Column không chiếm hết chiều cao
            children: [
              // --- PHẦN TRÊN: Ảnh và nội dung ---
              Container(
                height: 120, // Chiều cao của phần trên
                child: Stack(
                  children: [
                    // Ảnh nền hoặc nội dung chính
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.network(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQn2nmWoa-66Yo5xylQwIiAxtvMrK2pB2l4CA&s",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Nội dung text ở giữa
                    Center(
                      child: Text(
                        "DISCOUNT 50%",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.black54, blurRadius: 4),
                          ],
                        ),
                      ),
                    ),
                    // Đường nét đứt (thêm vào sau cùng để hiện lên trên)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0, // Đặt ở cuối phần trên
                      height: 20, // Chiều cao của đường đứt
                      child: CustomPaint(
                        painter: DashedLinePainter(
                          color: Colors.grey[400]!,
                          dashWidth: 6,
                          gapWidth: 4,
                          strokeWidth: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- PHẦN DƯỚI: Các bán nguyệt lõm xếp cạnh nhau ---
              ClipPath(
                clipper: BottomNotchClipper(
                  notchRadius: 10,
                ), // Các bán nguyệt dưới
                child: Container(
                  color: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.white),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Redeem now and get exclusive benefits!",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10), // Khoảng cách cuối cùng
            ],
          ),
        ),
      ),
    );
  }
}
