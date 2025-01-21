package com.sist.web.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.sist.common.util.StringUtil;
import com.sist.web.model.KakaoPayApproveRequest;
import com.sist.web.model.KakaoPayApproveResponse;
import com.sist.web.model.KakaoPayCancelRequest;
import com.sist.web.model.KakaoPayCancelResponse;
import com.sist.web.model.KakaoPayReadyRequest;
import com.sist.web.model.KakaoPayReadyResponse;

@Service("kakaoPayService")
public class KakaoPayService {

	private static Logger logger = LoggerFactory.getLogger(KakaoPayService.class);

	// Client ID
	@Value("#{env['kakaopay.client.id']}")
	private String KAKAOPAY_CLIENT_ID;

	// Client Secret
	@Value("#{env['kakaopay.client.secret']}")
	private String KAKAOPAY_CLIENT_SECRET;

	// Secret key
	@Value("#{env['kakaopay.secret.key']}")
	private String KAKAOPAY_SECRET_KEY;

	// 카카오페이 Ready URL
	@Value("#{env['kakaopay.ready.url']}")
	private String KAKAOPAY_READY_URL;

	// 카카오페이 Approval URL
	@Value("#{env['kakaopay.approval.url']}")
	private String KAKAOPAY_APPROVAL_URL;

	// 카카오페이 Cancel URL
	@Value("#{env['kakaopay.cancel.url']}")
	private String KAKAOPAY_CANCEL_URL;

	// 결제 성공 시 URL
	@Value("#{env['kakaopay.client.success.url']}")
	private String KAKAOPAY_CLIENT_SUCCESS_URL;

	// 결제 취소 시 URL
	@Value("#{env['kakaopay.client.cancel.url']}")
	private String KAKAOPAY_CLIENT_CANCEL_URL;

	// 결제 실패 시 URL
	@Value("#{env['kakaopay.client.fail.url']}")
	private String KAKAOPAY_CLIENT_FAIL_URL;

	// 카카오페이 Request 헤더
	private HttpHeaders kakaoPayHeaders;

	// 카카오페이 Request 헤더 설정
	@PostConstruct
	private void postConstruct() {

		kakaoPayHeaders = new HttpHeaders();

		kakaoPayHeaders.set("Authorization", "SECRET_KEY " + KAKAOPAY_SECRET_KEY);
		kakaoPayHeaders.set("Content-Type", "application/json");
	}

	// 카카오페이 Ready 호출 (결제 준비)
	public KakaoPayReadyResponse ready(KakaoPayReadyRequest kakaoPayReadyRequest) {

		KakaoPayReadyResponse kakaoPayReadyResponse = null;

		StringBuilder log = new StringBuilder();

		log.append("\n####################################");
		log.append("\n[KakaoPayService] ready");
		log.append("\n####################################");

		if (kakaoPayReadyRequest != null) {
			log.append(kakaoPayReadyRequest.toString());

			Map<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("cid", KAKAOPAY_CLIENT_ID); // 가맹점 코드, 10자 (Client ID)

			if (!StringUtil.isEmpty(kakaoPayReadyRequest.getCid())) {
				parameters.put("cid_secret", kakaoPayReadyRequest.getCid());
			}

			parameters.put("partner_order_id", kakaoPayReadyRequest.getPartner_order_id());
			parameters.put("partner_user_id", kakaoPayReadyRequest.getPartner_user_id());
			parameters.put("item_name", kakaoPayReadyRequest.getItem_name());

			if (!StringUtil.isEmpty(kakaoPayReadyRequest.getItem_code())) {
				parameters.put("item_code", kakaoPayReadyRequest.getItem_code());
			}

			parameters.put("quantity", kakaoPayReadyRequest.getQuantity());
			parameters.put("total_amount", kakaoPayReadyRequest.getTotal_amount());

			logger.debug("totalAmount : " + kakaoPayReadyRequest.getTotal_amount());

			parameters.put("tax_free_amount", kakaoPayReadyRequest.getTax_free_amount());

			if (kakaoPayReadyRequest.getVat_amount() > 0) {
				parameters.put("vat_amount", kakaoPayReadyRequest.getVat_amount());
			}

			if (kakaoPayReadyRequest.getGreen_deposit() > 0) {
				parameters.put("green_deposit", kakaoPayReadyRequest.getGreen_deposit());
			}

			parameters.put("approval_url", KAKAOPAY_CLIENT_SUCCESS_URL);
			parameters.put("cancel_url", KAKAOPAY_CLIENT_CANCEL_URL);
			parameters.put("fail_url", KAKAOPAY_CLIENT_FAIL_URL);

			if (!StringUtil.isEmpty(kakaoPayReadyRequest.getAvailable_cards())) {
				parameters.put("available_cards", kakaoPayReadyRequest.getAvailable_cards());
			}

			if (!StringUtil.isEmpty(kakaoPayReadyRequest.getPayment_method_type())) {
				parameters.put("payment_method_type", kakaoPayReadyRequest.getPayment_method_type());
			}

			if (kakaoPayReadyRequest.getInstall_month() > 0) {
				parameters.put("install_month", kakaoPayReadyRequest.getInstall_month());
			}

			if (!StringUtil.isEmpty(kakaoPayReadyRequest.getUse_share_installment())) {
				parameters.put("use_share_installment", kakaoPayReadyRequest.getUse_share_installment());
			}

			if (!StringUtil.isEmpty(kakaoPayReadyRequest.getCustom_json())) {
				parameters.put("custom_json", kakaoPayReadyRequest.getCustom_json());
			}

			logger.debug("1111111111111111111111");

			// HTTP Header와 HTTP Body 설정
			// 요청하기 위해서 header와 body를 합치기
			// Spirng FrameWork에서 제공해주는 HttpEntity 클래스에 Header와 Body를 합치기
			HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<Map<String, Object>>(parameters, kakaoPayHeaders);
			// parameters : Body, kakaoPayHeaders : Header

			// Spring에서 제공하는 Http 통신 처리를 위한 유틸리티 클래스
			// 클라이언트 쪽에서 http 요청을 만들고, 서버의 응답을 처리하는 데 유용
			RestTemplate restTemplate = new RestTemplate();

			// postForEntity : POST 요청을 보내고, 응답을 ResponseEntity로 반환받음
			ResponseEntity<KakaoPayReadyResponse> responseEntity = restTemplate.postForEntity(KAKAOPAY_READY_URL, requestEntity,
					KakaoPayReadyResponse.class);

			logger.debug("22222222222222222222222");

			if (responseEntity != null) {
				// 결과가 제대로 왔다면
				log.append("\nready statusCode : " + responseEntity.getStatusCode());

				kakaoPayReadyResponse = responseEntity.getBody();

				if (kakaoPayReadyResponse != null) {
					log.append("\nbody : \n " + kakaoPayReadyResponse);
				} else {
					log.append("\nbody : body is null");
				}
			} else {
				log.append("\nready : ResponseEntity is null");
			}

		}

		// return 하기 직전에 StringBuilder 값 찍기
		log.append("\n####################################");
		logger.info(log.toString());
		log.append("\n####################################");

		return kakaoPayReadyResponse;
	}

	// 카카오페이 결제 승인 요청
	public KakaoPayApproveResponse approve(KakaoPayApproveRequest kakaoPayApproveRequest) {

		KakaoPayApproveResponse kakaoPayApproveResponse = null;
		StringBuilder log = new StringBuilder();

		log.append("\n####################################");
		log.append("\n[KakaoPayService] approve");
		log.append("\n####################################");

		if (kakaoPayApproveRequest != null) {

			log.append(kakaoPayApproveRequest.toString());

			Map<String, Object> parameters = new HashMap<String, Object>();

			// 필수 입력값 넣기
			// 필수 입력값이 아니면 if문 처리
			parameters.put("cid", KAKAOPAY_CLIENT_ID);

			if (!StringUtil.isEmpty(kakaoPayApproveRequest.getCid_secret())) {
				parameters.put("cid_secret", kakaoPayApproveRequest.getCid_secret());
			}

			parameters.put("tid", kakaoPayApproveRequest.getTid());
			parameters.put("partner_order_id", kakaoPayApproveRequest.getPartner_order_id());
			parameters.put("partner_user_id", kakaoPayApproveRequest.getPartner_user_id());
			parameters.put("pg_token", kakaoPayApproveRequest.getPg_token());

			if (!StringUtil.isEmpty(kakaoPayApproveRequest.getPayload())) {
				parameters.put("payload", kakaoPayApproveRequest.getPayload());
			}

			if (!StringUtil.isEmpty(kakaoPayApproveRequest.getTotal_amount()) && kakaoPayApproveRequest.getTotal_amount() > 0) {
				parameters.put("total_amount", kakaoPayApproveRequest.getTotal_amount());
			}

			HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<Map<String, Object>>(parameters, kakaoPayHeaders);

			RestTemplate restTemplate = new RestTemplate();

			ResponseEntity<KakaoPayApproveResponse> responseEntity = restTemplate.postForEntity(KAKAOPAY_APPROVAL_URL, requestEntity,
					KakaoPayApproveResponse.class);

			if (responseEntity != null) {
				kakaoPayApproveResponse = responseEntity.getBody();

				if (kakaoPayApproveResponse != null) {
					log.append("\napprove body : \n" + kakaoPayApproveResponse);
				} else {
					log.append("\napprove body : body is null");
				}
			} else {
				log.append("\napprove : ResponseEntity is null");
			}

		}

		log.append("\n####################################");
		logger.info(log.toString());
		log.append("\n####################################");

		return kakaoPayApproveResponse;
	}

	// 카카오페이 결제취소
	public KakaoPayCancelResponse cancel(KakaoPayCancelRequest kakaoPayCancelRequest) {

		KakaoPayCancelResponse kakaoPayCancelResponse = null;
		StringBuilder log = new StringBuilder();

		log.append("\n####################################");
		log.append("\n[KakaoPayService] cancel");
		log.append("\n####################################");

		if (kakaoPayCancelRequest != null) {
			log.append(kakaoPayCancelRequest.toString());

			Map<String, Object> parameters = new HashMap<String, Object>();

			// 필수 입력값 넣기
			// 필수 입력값이 아니면 if문 처리
			parameters.put("cid", KAKAOPAY_CLIENT_ID);

			parameters.put("cid", kakaoPayCancelRequest.getCid()); // 필수값
			parameters.put("tid", kakaoPayCancelRequest.getTid()); // 필수값
			parameters.put("cancel_amount", kakaoPayCancelRequest.getCancel_amount()); // 필수값
			parameters.put("cancel_tax_free_amount", kakaoPayCancelRequest.getCancel_tax_free_amount()); // 필수값

			// 선택값 제거
			// if (!StringUtil.isEmpty(kakaoPayCancelRequest.getCancel_vat_amount())) {
//			     parameters.put("cancel_vat_amount", kakaoPayCancelRequest.getCancel_vat_amount());
			// }
			// if (!StringUtil.isEmpty(kakaoPayCancelRequest.getCancel_available_amount()))
			// {
//			     parameters.put("cancel_available_amount", kakaoPayCancelRequest.getCancel_available_amount());
			// }
			// if (!StringUtil.isEmpty(kakaoPayCancelRequest.getPayload())) {
//			     parameters.put("payload", kakaoPayCancelRequest.getPayload());
			// }

			logger.debug("1111111111111111111111");

			HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<Map<String, Object>>(parameters, kakaoPayHeaders);

			RestTemplate restTemplate = new RestTemplate();

			ResponseEntity<KakaoPayCancelResponse> responseEntity = restTemplate.postForEntity(KAKAOPAY_CANCEL_URL, requestEntity,
					KakaoPayCancelResponse.class);

			logger.debug("22222222222222222222222");

			if (responseEntity != null) {
				// 결과가 제대로 왔다면
				log.append("\nready statusCode : " + responseEntity.getStatusCode());

				kakaoPayCancelResponse = responseEntity.getBody();

				if (kakaoPayCancelResponse != null) {
					log.append("\nbody : \n " + kakaoPayCancelResponse);
				} else {
					log.append("\nbody : body is null");
				}

			} else {
				log.append("\nready : ResponseEntity is null");
			}

		}

		// return 하기 직전에 StringBuilder 값 찍기
		log.append("\n####################################");
		logger.info(log.toString());
		log.append("\n####################################");

		return kakaoPayCancelResponse;
	}

}
