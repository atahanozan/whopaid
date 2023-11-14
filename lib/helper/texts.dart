import 'package:flutter/material.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/text_styles.dart';

class TextsTR {
  static const String btnForgotPassword = "Şifremi Unuttum";
  static const String btnLogin = "Giriş Yap";
  static const String btnRegister = "Kayıt Ol";
  static const String btnYes = "Evet";
  static const String btnNo = "Hayır";
  static const String btnSend = "Gönder";
  static const String btnForward = "İleri";
  static const String btnBackward = "Geri";
  static const String btnStart = "Başla";
  static const String btnEnd = "Bitti";
  static const String btnCalculate = "Hesapla";
  static const String btnShare = "Paylaş";
  static const String btnAdd = "Ekle";
  static const String btnRemove = "Kaldır";
  static const String btnChooseDate = "Tarih Seç";
  static const String btnCancel = "İptal";
  static const String btnOkey = "Tamam";
  static const String btnEdit = "Düzenle";
  static const String btnSave = "Kaydet";
  static const String btnDelete = "Sil";
  static const String askDeleteAcc = "Hesabı sil?";
  static const String askLogout = "Çıkış yap?";
  static const String connectErr =
      "İnternet bağlantınız bulunmamaktadır. Lütfen kontrol ediniz.";
  static const String txtfldSearch = "Ara";
  static const String lgnPgLogin = "Giriş";
  static const String lgnPgLoginSub =
      "E-mail adresi ve şifre ile giriş yapın. Eğer üye olmadıysanız Kayıt Ol bölümüne gidebilirsiniz.";
  static const String lgnPgEmail = "E-mail";
  static const String lgnPgPassword = "Şifre";
  static const String lgnPgErrEmail =
      "Lütfen e-mail bilgisini boş bırakmayınız.";
  static const String lgnPgErrPassword =
      "Lütfen şifre bilgisini boş bırakmayınız.";
  static const String frgtpssPgForgotPass = "Şifremi Unuttum";
  static const String rgstrPgRegister = "Kayıt Ol";
  static const String rgstrPgRegisterSub =
      "Aşağıdaki bilgileri eksiksiz doldurarak kayıt işleminiz gerçekleştiriniz.";
  static const String rgstrPgNameSur = "Ad Soyad";
  static const String rgstrPgErrNameSur =
      "Lütfen isim soyisim bilgisini boş bırakmayınız.";
  static const String calcpgTitle = "Hesaplama";
  static const String calcpgStart = "Siz harcayın, hesabını bize bırakın";
  static const String calcpgPayments = "Ödemeler:";
  static const String calcpgBill = "Fatura";
  static const String calcpgPayFrom = "Ödeyen";
  static const String calcpgPayDue = "Tutar";
  static const String calcpgTotal = "Toplam";
  static const String calcpgPerPerson = "Kişi Başı";
  static const String calcpgSubscriber = "Katılımcılar";
  static const String calcpgCalculateExp =
      "Liste bitene kadar hesapla butonuna basabilirsiniz";
  static const String calcpgErrShare =
      "Paylaşım için en az bir hesaplama yapmalısınız!";
  static const String calcpgErrSendMessage = "Mesaj ilgili kişilere iletildi.";
  static const String calcpgErrChoosePerson = "En az bir kişi seçmelisiniz.";
  static const String calcpgErrRegisterPayment =
      "Lütfen tutarları eksiksiz girdiğinizden emin olunuz.";

  static const String calcpgErrOverPerson =
      "Eklediğiniz kişi sayısı verdiğiniz adetten fazla. Geri dönerek kişi sayısını artırınız.";
  static const String calcpgErrLesPerson =
      "Girilen kişi sayısı verilen adetten düşük. Hiç harcama yapmayan kişileri 0 olarak eklediğinizden eminseniz geri giderek kişi sayısını güncelleyiniz.";
  static const String calcpgWarnPaysDone = "Ödemeler aşağıdaki gibi olmalıdır.";
  static const String calcpgWarnChsDat = "Tarih Seç";
  static const String calcpgScdTitle = "Katılımcılar";
  static Widget calcpgMessage(
    String datetime,
    String debt,
    String payment,
    BuildContext context,
  ) {
    final utiltext = RichText(
      text: TextSpan(
        text: datetime,
        style: CustomTextStyle.headerSmall(context),
        children: [
          TextSpan(
            text: " Tarihindeki organizasyon için ",
            style: CustomTextStyle.bodyLarge(context),
          ),
          TextSpan(
            text: debt,
            style: CustomTextStyle.headerSmall(context),
          ),
          TextSpan(
            text: " kişisine ",
            style: CustomTextStyle.bodyLarge(context),
          ),
          TextSpan(
            text: payment,
            style: CustomTextStyle.headerSmall(context),
          ),
          TextSpan(
            text: " TL tutarında ödeme yapmanız gerekmektedir. ",
            style: CustomTextStyle.bodyLarge(context),
          ),
        ],
      ),
    );

    return utiltext;
  }

  static Widget calcpgResult(
    String payee,
    String debt,
    String payment,
    BuildContext context,
  ) {
    final utiltext = RichText(
      text: TextSpan(
        text: payee,
        style: CustomTextStyle.headerSmall(context),
        children: [
          TextSpan(
            text: " kişisi ",
            style: CustomTextStyle.bodyLarge(context),
          ),
          TextSpan(
            text: debt,
            style: CustomTextStyle.headerSmall(context),
          ),
          TextSpan(
            text: " kişisine ",
            style: CustomTextStyle.bodyLarge(context),
          ),
          TextSpan(
            text: payment,
            style: CustomTextStyle.headerSmall(context),
          ),
          TextSpan(
            text: " TL tutarında ödeme yapacak",
            style: CustomTextStyle.bodyLarge(context),
          ),
        ],
      ),
    );

    return utiltext;
  }

  static const String commercialpgFirst =
      "Arkadaşlarınla dışarı çıkarken harcama hesaplamalarını artık düşünme";
  static const String commercialpgSecond =
      "Sen eğlencene bak, hesaplamaları biz yaparız. Unutma ne kadar harcarsan Bütçe Savaşlarında o kadar yukarı çıkarsın...";
  static const String commercialpgThird =
      "Hemen hesaplamalara başlamak için üyelik oluştur ve arkadaşlarını ekle";
  static const String utilsErrFriend = "Arkadaş listesinden kaldır?";
  static Widget utilsRideText(
    String totalPay,
    int index,
    BuildContext context,
  ) {
    final utiltext = RichText(
      text: TextSpan(
        text: "Toplam Harcama:\n",
        style: index == 0
            ? CustomTextStyle.bodySmall(context).copyWith(
                color: CustomColors.backGround(context),
                fontWeight: FontWeight.bold,
              )
            : CustomTextStyle.bodySmall(context).copyWith(
                color: CustomColors.foreGround(context),
                fontWeight: FontWeight.bold,
              ),
        children: [
          TextSpan(
            text: totalPay,
            style: index == 0
                ? CustomTextStyle.bodySmall(context).copyWith(
                    color: CustomColors.backGround(context),
                    fontWeight: FontWeight.bold,
                  )
                : CustomTextStyle.bodySmall(context).copyWith(
                    color: CustomColors.foreGround(context),
                    fontWeight: FontWeight.bold,
                  ),
          ),
        ],
      ),
    );

    return utiltext;
  }

  static const String chsavtPgtitle = "Avatar Seç";
  static const String chsavtPgErr = "En az bir avatar seçmelisiniz.";
  static const String scrtPgTitle = "Gizlilike ve Güvenlik";
  static const String scrtPgScdTitle = "Gizli";
  static const String scrtPgExplain =
      "Hesabınızı gizlediğinizde, Bütçe Savaşları sayfasında görünmezsiniz. Ancak kullanıcı adınız ile arama yapıldığında arayan kişiye görünmektedir.";
  static const String sttngsPgTitle = "Profil Ayarları";
  static const String sttngsPgAboutSelf = "Hakkında";
  static const String sttngsPgUserName = "Kullanıcı Adı";
  static const String sttngsPgTotalDue = "Toplam Harcama";
  static const String addfrPgTitle = "Arkadaş Ekle";
  static const String addfrPgErr = "Mevcut kullanıcı";
  static const String msgPgTitle = "Mesajlar";
  static const String ntfPgTitle = "Bildirimler";
  static const String ntfPgErr = "Bildirim Yok!";
  static const String chsUsernameTitle = "Kullanıcı Adı";
  static const String chsUserErr =
      "Geçerli bir kullanıcı adı seçiniz veya sizin için belirlenen kullanıcı adını kullanınız.";
}
