import 'package:flutter/material.dart';
import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/info_payment_model.dart';
import 'package:cam_id/main/data/model/linked_payment_method_model.dart';
import 'package:cam_id/main/utils/widget/image_widget.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:cam_id/res/app_fonts.dart';
import 'package:cam_id/res/app_images.dart';

enum PaymentType { CANCEL, TOPUP, FTTH, FTTH_AUTO_RENEW }

class CancelAutoRenewBottomSheet extends StatelessWidget {
  final LinkedPaymentMethodModel? linkedPaymentMethodModel;
  final InfoPayment? infoPayment;
  final PaymentType paymentType;
  final void Function(PaymentType paymentType, String paymentMethod) onConfirm;
  final VoidCallback onCancel;

  const CancelAutoRenewBottomSheet({
    super.key,
    this.linkedPaymentMethodModel,
    this.infoPayment,
    required this.paymentType,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    String getNumberText() {
      if (infoPayment == null) return '';
      switch (paymentType) {
        case PaymentType.TOPUP:
        case PaymentType.FTTH:
          return infoPayment!.topupNumber ?? '';
        case PaymentType.CANCEL:
          return infoPayment!.service ?? '';
        case PaymentType.FTTH_AUTO_RENEW:
          return infoPayment!.topupNumber ?? '';
      }
    }

    String getNumberTitle() {
      switch (paymentType) {
        case PaymentType.TOPUP:
          return l10n.top_up_number;
        case PaymentType.FTTH:
        case PaymentType.FTTH_AUTO_RENEW:
          return l10n.accountNumber;
        case PaymentType.CANCEL:
          return l10n.service;
      }
    }

    String getAmountText() {
      if (infoPayment == null) return '';
      if (paymentType == PaymentType.CANCEL) {
        if (infoPayment!.originalService?.toLowerCase() == 'top-up' ||
            infoPayment!.originalService?.toLowerCase() == 'ftth') {
          return infoPayment!.phoneNumber ?? '';
        }
        return infoPayment!.amountCancel ?? '';
      } else {
        return infoPayment!.amount ?? '';
      }
    }

    String getAmountTitle() {
      if (paymentType == PaymentType.CANCEL) {
        if (infoPayment!.originalService?.toLowerCase() == 'top-up') {
          return l10n.phone_number;
        } else if (infoPayment!.originalService?.toLowerCase() == 'ftth') {
          return l10n.accountNumber;
        }
        return '';
      } else {
        return l10n.amount;
      }
    }

    String? getAutoRenewText() {
      if (infoPayment == null) return null;
      switch (paymentType) {
        case PaymentType.CANCEL:
          return infoPayment!.amountCancel;
        case PaymentType.FTTH_AUTO_RENEW:
          return "";
        case PaymentType.TOPUP:
        case PaymentType.FTTH:
          return infoPayment!.autoRenew;
      }
    }

    String getAutoRenewTitle() {
      if (paymentType == PaymentType.CANCEL) {
        return l10n.amount;
      } else if (paymentType == PaymentType.FTTH_AUTO_RENEW) {
        return l10n.content_auto_renew_FTTH;
      } else {
        return l10n.auto_renew;
      }
    }

    return PopScope(
      onPopInvoked: (intent) async => false,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Question
            if (infoPayment != null)
              Text(
                paymentType == PaymentType.CANCEL
                    ? infoPayment!.questionCancel ?? ''
                    : infoPayment!.question ?? '',
                style: AppTextFonts.poppinsSemiBold.copyWith(
                  fontSize: 16,
                  color: AppColors.color_1618,
                ),
              ),
            const SizedBox(height: 16),

            // Number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getNumberTitle(),
                  style: AppTextFonts.poppinsRegular.copyWith(
                    fontSize: 14,
                    color: AppColors.color_8588,
                  ),
                ),
                Text(
                  getNumberText(),
                  style: AppTextFonts.poppinsMedium.copyWith(
                    fontSize: 14,
                    color: AppColors.color_1618,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getAmountTitle(),
                  style: AppTextFonts.poppinsRegular.copyWith(
                    fontSize: 14,
                    color: AppColors.color_8588,
                  ),
                ),
                Text(
                  getAmountText(),
                  style: AppTextFonts.poppinsMedium.copyWith(
                    fontSize: 14,
                    color: AppColors.color_1618,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // AutoRenew / Warning
            if (getAutoRenewText() != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (paymentType == PaymentType.FTTH)
                    Text(
                      getAutoRenewTitle(),
                      style: AppTextFonts.poppinsRegular.copyWith(
                        fontSize: 14,
                        color: AppColors.color_8588,
                      ),
                    ),
                  Text(
                    getAutoRenewText()!,
                    style: AppTextFonts.poppinsMedium.copyWith(
                      fontSize: 14,
                      color: AppColors.color_1618,
                    ),
                  ),
                ],
              ),
            if (infoPayment?.contentWarning != null &&
                infoPayment!.contentWarning!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  infoPayment!.contentWarning!,
                  style: AppTextFonts.poppinsRegular.copyWith(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Linked Payment Method
            if (linkedPaymentMethodModel != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (linkedPaymentMethodModel!.image != null)
                        SafeImage(
                          url: linkedPaymentMethodModel!.image!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          placeholder: AppImages.imgEntertainmentDefault,
                          errorAsset: AppImages.imgEntertainmentDefault,
                        )
                      else
                        const SizedBox(width: 40, height: 40),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            linkedPaymentMethodModel!.accountPartner ?? '',
                            style: AppTextFonts.poppinsMedium.copyWith(
                              fontSize: 14,
                              color: AppColors.color_1618,
                            ),
                          ),
                          Text(
                            linkedPaymentMethodModel!.linkedDate ?? '',
                            style: AppTextFonts.poppinsRegular.copyWith(
                              fontSize: 12,
                              color: AppColors.color_8588,
                            ),
                          ),
                          if (linkedPaymentMethodModel!.expiredDate != null &&
                              linkedPaymentMethodModel!.expiredDate!.isNotEmpty)
                            Text(
                              '${l10n.expires}: ${linkedPaymentMethodModel!.expiredDate}',
                              style: AppTextFonts.poppinsRegular.copyWith(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () => onConfirm(
                paymentType,
                linkedPaymentMethodModel?.partnerCode ?? '',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.color_E11B,
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(
                l10n.confirm,
                style: AppTextFonts.poppinsSemiBold.copyWith(
                  fontSize: 16,
                  color: AppColors.color_FFFF,
                ),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.color_5F5F,
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(
                l10n.cancel,
                style: AppTextFonts.poppinsSemiBold.copyWith(
                  fontSize: 16,
                  color: AppColors.color_1618,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
