import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/other_payment_method_model.dart';
import 'package:cam_id/main/utils/constant.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_images.dart';
import 'package:cam_id/router.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OtherPaymentBottomSheet extends StatelessWidget {
  final List<OtherPaymentMethodModel> listPaymentMethod;
  final String termsAndCondition;
  const OtherPaymentBottomSheet({
    super.key,
    required this.listPaymentMethod,
    required this.termsAndCondition
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 220,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.choose_payment_method,
            style: const TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 70,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: listPaymentMethod.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = listPaymentMethod[index];
                return _buildPaymentItem(item);
              },
            ),
          ),
          const SizedBox(height: 16),

          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.color_EBEB,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_box, color: AppColors.color_FF1D),

              const SizedBox(width: 8),

              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!.by_adding_,
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)!.terms_and_conditions,
                        style: const TextStyle(
                          color: AppColors.color_FF1D,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.push(
                              PATH_TERMS,
                              extra: termsAndCondition,
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPaymentItem(OtherPaymentMethodModel item) {
    final partnerCode = item.partnerCode?.toLowerCase();
    final isCardPayment = partnerCode == Constant.ABA_CARD.toLowerCase() ||
        partnerCode == Constant.CREDIT_CARD.toLowerCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.network(
            item.image??"",
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),

          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name??"-----",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isCardPayment)
              Image.asset(
                AppImages.imgListPaymentMethodTemp,
                width: 110,
              ),

              if (!isCardPayment)
                Text(
                  item.description ?? "-----",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

            ],
          ),
        ],
      ),
    );
  }
}

