/****************************************************************************
 *  Copyright 2016 Qualcomm Technologies International, Ltd.
 *****************************************************************************/
/*! \file csr_mesh_crypto.c
 *  \brief cryptographic library for csr mesh.
 *
 *   This file exposes operations for ECDH and AES-CCM implemented by OpenSSL
 */
/*****************************************************************************/
#include <stdio.h>
#include <string.h>
#include <openssl/opensslconf.h> /* for OPENSSL_NO_ECDH */
#include <openssl/crypto.h>
#include <openssl/bn.h>
#include <openssl/aes.h>
#include <openssl/ec.h>
#include <openssl/ecdh.h>
#include <openssl/objects.h>
#include <openssl/rand.h>
#include <openssl/sha.h>
#include <openssl/err.h>
#include <openssl/hmac.h>
#include "csr_mesh_crypto.h"
//#define CSR_DEBUG_CRYPTO 0
#define CSR_CRYPTO_NONCE_SIZE 13
#define CSR_CRYPTO_MIC_TAG_SIZE 4
#define CSR_CRYPTO_ADD_AUTH_DATA_SIZE 0

/***********************************************************************
 * csrCreateEphemeralKeypair
 * Description: Generates a 192P Ellipcle curve and returns Private and
 * Public key pair from the same.
 * input:
 *	CSR_AUTH_EPH_KEY_T *	: Structure to hold the key pair
 * return:
 *	1 on Success 0 on Failure
 ***********************************************************************/
CsrUint8 csrCreateEphemeralKeypair (CSR_AUTH_EPH_KEY_T *k)
{
    EC_KEY *a = NULL;
    const EC_GROUP *group;
    BIGNUM *q = NULL;
    BIGNUM *x = NULL;
    BIGNUM *y = NULL;
    int ret = 0;
    
    if (k == NULL)
        goto err;
    
    if ((sizeof (k->privatekey) < 24) ||
        (sizeof (k->publickey.pubKeyX) < 24) ||
        (sizeof (k->publickey.pubKeyY) < 24))
    {
        fprintf (stdout, "\nInsufficient Buffer\n");
        goto err;
    }
    
    q = BN_new();
    x = BN_new();
    y = BN_new();
    const BIGNUM *p = q;
    
    if (q == NULL)
        goto err;
    
    if (x == NULL)
        goto err;
    
    if (y == NULL)
        goto err;
    
    a = EC_KEY_new_by_curve_name (NID_X9_62_prime192v1);
    
    if (a == NULL)
    {
        fprintf (stdout, "\nCould not get curve\n");
        goto err;
    }
    
    if (!EC_KEY_generate_key (a))
    {
        fprintf (stdout, "Error generating key\n");
        goto err;
    }
    
    group = EC_KEY_get0_group (a);
    const EC_POINT *a_pub = EC_KEY_get0_public_key (a);
    
    if (a_pub == NULL)
    {
        fprintf (stdout, "\nCould not get public key for curve\n");
        goto err;
    }
    
    p = EC_KEY_get0_private_key (a);
#ifdef CSR_DEBUG_CRYPTO
    fprintf (stdout, "\nDebug: Private: \t");
    BN_print_fp (stdout, p);
#endif
    BN_bn2bin (p, (CsrUint8 *)k->privatekey);
    
    if (EC_POINT_get_affine_coordinates_GFp (group, a_pub, x, y, NULL))
    {
#ifdef CSR_DEBUG_CRYPTO
        fprintf (stdout, "\nDebug: Public X: \t");
        BN_print_fp (stdout, x);
        fprintf (stdout, "\nDebug: Public Y: \t");
        BN_print_fp (stdout, y);
#endif
        BN_bn2bin (x, (CsrUint8 *)k->publickey.pubKeyX);
        BN_bn2bin (y, (CsrUint8 *)k->publickey.pubKeyY);
    }
    else
        goto err;
    
    ret = 1;
err:
    
    if (q)
        BN_free (q);
    
    if (x)
        BN_free (x);
    
    if (y)
        BN_free (y);
    
    return ret;
}

/***********************************************************************
 * csrGenerateSecret
 * Description: Generates a ECDH multiplcation of 24 byte private key and
 * an EC point.
 * input:
 *	CsrUint8 *				:24 byte private_key
 *	CSR_AUTH_PUB_KEY_T *	:2 * 24 byte public key (EC point)
 *	CsrUint8 *				:24 byte shared secret
 * return:
 *	1 on Success 0 on Failure
 ***********************************************************************/
CsrUint8 csrGenerateSecret (const CsrUint8 *prk,
                            const CSR_AUTH_PUB_KEY_T *pub,
                            CsrUint8 *secret)
{
    int aout;
    int ret = 0;
    CsrUint8 *abuf = NULL;
    BIGNUM *pr = NULL;
    BIGNUM *pub_x = NULL;
    BIGNUM *pub_y = NULL;
    
    if ((prk == NULL) || (pub == NULL) || (secret == NULL))
        goto err;
    
    pr = BN_new();
    pub_x = BN_new();
    pub_y = BN_new();
    abuf = (CsrUint8 *)OPENSSL_malloc (CSR_CRYPTO_SHA256_HASH_SIZE);
    
    if (abuf == NULL)
        goto err;
    
    if (pr == NULL)
        goto err;
    
    if (pub_x == NULL)
        goto err;
    
    if (pub_y == NULL)
        goto err;
    
    BN_bin2bn ((CsrUint8 *)prk, CSR_CRYPTO_PRIVATE_KEY_SIZE, pr);
    BN_bin2bn ((CsrUint8 *)pub->pubKeyX, CSR_CRYPTO_PUBLIC_KEY_SIZE, pub_x);
    BN_bin2bn ((CsrUint8 *)pub->pubKeyY, CSR_CRYPTO_PUBLIC_KEY_SIZE, pub_y);
#ifdef CSR_DEBUG_CRYPTO
    fprintf (stdout, "\nDebug(%s): Private: \t", __FUNCTION__);
    BN_print_fp (stdout, pr);
    fprintf (stdout, "\nDebug(%s): Public X: \t", __FUNCTION__);
    BN_print_fp (stdout, pub_x);
    fprintf (stdout, "\nDebug(%s): Public Y: \t", __FUNCTION__);
    BN_print_fp (stdout, pub_y);
#endif
    //create new key and EC_KEY_set_private_key
    EC_KEY *a = EC_KEY_new_by_curve_name (NID_X9_62_prime192v1);
    
    if (!EC_KEY_set_private_key (a, pr))
    {
        fprintf (stdout, "Could not set private key\n");
        goto err;
    }
    
    const EC_GROUP *group;
    group = EC_KEY_get0_group (a);
    EC_POINT *pt = EC_POINT_new (group);
    EC_POINT_set_affine_coordinates_GFp (group, pt, pub_x, pub_y, NULL);
    aout = ECDH_compute_key (abuf, CSR_CRYPTO_SHA256_HASH_SIZE, pt, a, NULL);
    
    if (aout < CSR_CRYPTO_SECRET_SIZE)
        goto err;
#ifdef CSR_DEBUG_CRYPTO
    int i;
    fprintf (stdout, "\nDebug(%s): ECDH Key (%d):\t", __FUNCTION__, aout);
    
    for (i = 0; i < aout; i++)
        fprintf (stdout, "%02X", abuf[i]);
    
#endif
    memcpy ((CsrUint8 *)secret, abuf, CSR_CRYPTO_SECRET_SIZE);
    ret = 1;
err:
    
    if (abuf)
        OPENSSL_free (abuf);
    
    if (pr)
        BN_free (pr);
    
    if (pub_x)
        BN_free (pub_x);
    
    if (pub_y)
        BN_free (pub_y);
    
    return ret;
}

/***********************************************************************
 * csrGenerateChallenge
 * Description: Generates an SHA256 MAC using appKey
 * input:
 *	CsrUint8 *					: appKey from catalog
 *	CsrUint8 *					: 24 byte shared secret
 *	CSR_AUTH_PUB_KEY_T *		: 2 * 24 byte public key local (EC point)
 *	CSR_AUTH_PUB_KEY_T *		: 2 * 24 byte public key remote (EC point)
 *	CsrUint8 *					: Random number (size CSR_CRYPTO_RAND_SIZE)
 *	CsrUint8 *		: buffer for generated MAC
 * return:
 *	1 on Success 0 on Failure
 ***********************************************************************/
CsrUint8 csrGenerateChallenge (CsrUint8 *appkey,
                               CsrUint8 *secret, CSR_AUTH_PUB_KEY_T *a,
                               CSR_AUTH_PUB_KEY_T *b, CsrUint8 *random_num, CsrUint8 *challenge1)
{
    int ret = 0;
    unsigned int i, len;
    CsrUint8 *buf = NULL;
    CsrUint8 *tmpbuf = NULL;
    CsrUint8 con_str[] = "Confirmation";
    int alen = (sizeof (con_str) - 1 ) + CSR_CRYPTO_SECRET_SIZE +
    (CSR_CRYPTO_PUBLIC_KEY_SIZE * 4 ) + CSR_CRYPTO_RAND_SIZE;
    
    if ((challenge1 == NULL) || (appkey == NULL) || (secret == NULL) ||
        (a == NULL) ||
        (b == NULL) || (random_num == NULL))
        goto err;
    
    buf = (CsrUint8 *)OPENSSL_malloc (alen);
    
    if (buf == NULL)
        goto err;
    
    i = 0;
    memcpy (buf + i, con_str, sizeof (con_str) - 1);
    i += sizeof (con_str) - 1;
    memcpy (buf + i, secret, CSR_CRYPTO_SECRET_SIZE);
    i += CSR_CRYPTO_SECRET_SIZE;
    memcpy (buf + i, a->pubKeyX, CSR_CRYPTO_PUBLIC_KEY_SIZE);
    i += CSR_CRYPTO_PUBLIC_KEY_SIZE;
    memcpy (buf + i, a->pubKeyY, CSR_CRYPTO_PUBLIC_KEY_SIZE);
    i += CSR_CRYPTO_PUBLIC_KEY_SIZE;
    memcpy (buf + i, b->pubKeyX, CSR_CRYPTO_PUBLIC_KEY_SIZE);
    i += CSR_CRYPTO_PUBLIC_KEY_SIZE;
    memcpy (buf + i, b->pubKeyY, CSR_CRYPTO_PUBLIC_KEY_SIZE);
    i += CSR_CRYPTO_PUBLIC_KEY_SIZE;
    memcpy (buf + i, random_num, CSR_CRYPTO_RAND_SIZE);
    i += CSR_CRYPTO_RAND_SIZE;
#ifdef CSR_DEBUG_CRYPTO
    fprintf (stdout, "\nDebug(%s): Challenge Input(%d):\t",
             __FUNCTION__, i);
    unsigned int x;
    
    for (x = 0; x < i; x++)
        fprintf (stdout, "%02x", (unsigned int) * (buf + x));
    
#endif
    tmpbuf = (CsrUint8 *)OPENSSL_malloc (CSR_CRYPTO_SHA256_HASH_SIZE);
    
    if (tmpbuf == NULL)
        goto err;
    
    HMAC_CTX ctx;
    HMAC_CTX_init (&ctx);
    HMAC_Init_ex (&ctx, appkey, CSR_CRYPTO_SHA256_HASH_SIZE,
                  EVP_sha256(), NULL);
    HMAC_Update (&ctx, buf, i);
    HMAC_Final (&ctx, tmpbuf, &len);
#ifdef CSR_DEBUG_CRYPTO
    fprintf (stdout, "\nDebug(%s): SHA256 HMAC(%d) :\t",
             __FUNCTION__, len);
    
    for (x = 0; x < len; x++)
        fprintf (stdout, "%02x", (unsigned int) * (tmpbuf + x));
    
#endif
    memcpy ((CsrUint8 *)challenge1, tmpbuf,
            CSR_CRYPTO_CHALLENGE_SIZE);
    HMAC_CTX_cleanup (&ctx);
    ret = 1;
err:
    
    if (buf)
        OPENSSL_free (buf);
    
    if (tmpbuf)
        OPENSSL_free (tmpbuf);
    
    return ret;
}

/***********************************************************************
 * csrGenerateSessionKey
 * Description: Generates an SHA256 MAC using shared secret
 * input:
 *	CsrUint8 *		: shared secret extended to 32 bytes
 *	CsrUint8 *		: 8 byte Diversifier
 *	CsrUint8 *		: buffer for MAC
 * return:
 *	1 on Success 0 on Failure
 ***********************************************************************/
CsrUint8 csrGenerateSessionKey (CsrUint8 *secret,
                                CsrUint8 *diversifier,
                                CsrUint8 *outbuf)
{
    int ret = 0;
    CsrUint8 *buf = NULL;
    CsrUint8 *tmpbuf = NULL;
    CsrUint8 con_str[] = "Session Key";
    int slen;
    unsigned int len, i;
    
    if ((outbuf == NULL) || (secret == NULL) || (diversifier == NULL))
        goto err;
    
    slen = sizeof (con_str) - 1;
    tmpbuf = (CsrUint8 *)OPENSSL_malloc (CSR_CRYPTO_SHA256_HASH_SIZE);
    buf = (CsrUint8 *)OPENSSL_malloc (slen + CSR_CRYPTO_DIVERSIFIER_SIZE);
    
    if ((buf == NULL) || (tmpbuf == NULL))
        goto err;
    
    i = 0;
    memcpy (buf + i, con_str, slen);
    i += slen;
    memcpy (buf + i, diversifier, CSR_CRYPTO_DIVERSIFIER_SIZE);
    i += CSR_CRYPTO_DIVERSIFIER_SIZE;
    HMAC_CTX ctx;
    HMAC_CTX_init (&ctx);
    HMAC_Init_ex (&ctx, secret, CSR_CRYPTO_SHA256_HASH_SIZE,
                  EVP_sha256(), NULL);
    HMAC_Update (&ctx, buf, i);
    HMAC_Final (&ctx, tmpbuf, &len);
#ifdef CSR_DEBUG_CRYPTO
    fprintf (stdout, "\nDebug(%s): Session Key :\t", __FUNCTION__);
    
    for (i = 0; i < len; i++)
        fprintf (stdout, "%02x", (unsigned int) * (tmpbuf + i));
    
#endif
    memcpy (outbuf, tmpbuf, CSR_CRYPTO_SESSIONKEY_SIZE);
    HMAC_CTX_cleanup (&ctx);
    ret = 1;
err:
    
    if (buf)
        OPENSSL_free (buf);
    
    if (tmpbuf)
        OPENSSL_free (tmpbuf);
    
    return ret;
}

/***********************************************************************
 * csrGenerateRandom
 * Description: Generates a cryptographically string random number
 * input:
 *	CsrUint8 *			: buffer for random number
 *	CsrUint16			: length
 * return:
 *	1 on Success 0 on Failure
 ***********************************************************************/
CsrUint8 csrGenerateRandom (CsrUint8 *buf, CsrUint16 len)
{
    int ret = 0;
    
    if ((buf == NULL) || (len == 0))
        goto err;
    
    if (RAND_pseudo_bytes (buf, len) == 0)
        goto err;
    
    ret = 1;
#ifdef CSR_DEBUG_CRYPTO
    int i;
    fprintf (stdout, "\n\nRAND generated:\t");
    
    for (i = 0; i < len; i++)
        fprintf (stdout, "%02x", (unsigned int) * (buf + i));
    
#endif
err:
    return ret;
}

/***********************************************************************
 * csrEncryptData
 * Description: AES-CCM encryption of a pkt
 *               AES key = 128 bit Session key
 *		nonce = SEQ || IV = 104 bits
 *		additional auth data = 0
 * input:
 *	CsrUint8 *			: in buffer
 *	CsrUint16			: data length
 *	CsrUint8 *			: 8 byte session key
 *	CsrUint8 *			: 10 byte IV
 *	CsrUint8 *			: 24bit sequence number
 *	CsrUint8 *			: out buffer
 * return:
 *	1 on Success 0 on Failure
 ***********************************************************************/
CsrUint8 csrEncryptData (CsrUint8 *data, CsrUint16 datalen,
                         CsrUint8 *sessionKey,
                         CsrUint8 *initVector, CsrUint8 *sequence, CsrUint8 *outbuf)
{
    EVP_CIPHER_CTX *ctx = NULL;
    CsrUint8 *nonce = NULL;
    int i, outlen=0;
    int ret = 0;
    
    if ((data == NULL) || (sessionKey == NULL) || (initVector == NULL) ||
        (sequence == NULL) || (outbuf == NULL))
        goto err;
    
    ctx = EVP_CIPHER_CTX_new();
    
    if (ctx == NULL)
        goto err;
    
    nonce = (CsrUint8 *)OPENSSL_malloc (CSR_CRYPTO_NONCE_SIZE);
    
    if (nonce == NULL)
        goto err;
    
    i = 0;
    memcpy (nonce + i, sequence, CSR_CRYPTO_SEQUENCE_SIZE);
    i += CSR_CRYPTO_SEQUENCE_SIZE;
    memcpy (nonce + i, initVector, CSR_CRYPTO_INIT_VECTOR_SIZE);
    i += CSR_CRYPTO_INIT_VECTOR_SIZE;
#ifdef CSR_DEBUG_CRYPTO
    int x;
    fprintf (stdout, "\n\n Nonce:\t");
    
    for (x = 0; x < CSR_CRYPTO_NONCE_SIZE; x++)
        fprintf (stdout, "%02x", (unsigned int) * (nonce + x));
    
#endif
    //TODO: failure check for EVP methods ??
    EVP_CIPHER_CTX_init (ctx);
    EVP_EncryptInit (ctx, EVP_aes_128_ccm(), 0, 0);
    EVP_CIPHER_CTX_ctrl (ctx, EVP_CTRL_CCM_SET_IVLEN,
                         CSR_CRYPTO_NONCE_SIZE, 0);
    EVP_CIPHER_CTX_ctrl (ctx, EVP_CTRL_CCM_SET_TAG,
                         CSR_CRYPTO_MIC_TAG_SIZE, 0);
    EVP_EncryptInit (ctx, 0, sessionKey, nonce);
    EVP_EncryptUpdate (ctx, 0, &outlen, 0, datalen);
    EVP_EncryptUpdate (ctx, outbuf, &outlen, data, datalen);
    EVP_EncryptFinal (ctx, &outbuf[outlen], &outlen);
    EVP_CIPHER_CTX_ctrl (ctx, EVP_CTRL_CCM_GET_TAG, CSR_CRYPTO_MIC_TAG_SIZE,
                         &outbuf[datalen]);
    ret = 1;
err:
    
    if (nonce)
        OPENSSL_free (nonce);
    
    if (ctx)
        EVP_CIPHER_CTX_cleanup (ctx);
    
    return ret;
}

/* MIC should be 4,8,12,16 */
CsrUint8 csrEncryptCCM (CsrUint8 *data, CsrUint32 datalen,
                        CsrUint8 *key, CsrUint8 len, CsrUint8 *nonce, CsrUint8 nlen,
                        CsrUint8 micsize, CsrUint8 *outbuf)
{
    EVP_CIPHER_CTX *ctx = NULL;
    int outlen=0;
    int ret = 0;
    
    printf ("\nKey length :%d",len);
    
    if ((data == NULL) || (key == NULL) ||
        (outbuf == NULL) || (nonce == NULL))
        goto err;
    
    ctx = EVP_CIPHER_CTX_new();
    
    if (ctx == NULL)
        goto err;
    
    if (nlen > 32) //MAX Nonce
        goto err;
    
    memset (outbuf, 0, outlen);
    EVP_CIPHER_CTX_init (ctx);
    EVP_EncryptInit (ctx, EVP_aes_128_ccm(), 0, 0);
    EVP_CIPHER_CTX_ctrl (ctx, EVP_CTRL_CCM_SET_IVLEN, nlen, 0);
    EVP_CIPHER_CTX_ctrl (ctx, EVP_CTRL_CCM_SET_TAG, micsize, 0);
    EVP_EncryptInit (ctx, 0, key, nonce);
    EVP_EncryptUpdate (ctx, 0, &outlen, 0, datalen);
    EVP_EncryptUpdate (ctx, outbuf, &outlen, data, datalen);
    EVP_EncryptFinal (ctx, &outbuf[outlen], &outlen);
    EVP_CIPHER_CTX_ctrl (ctx, EVP_CTRL_CCM_GET_TAG, micsize,
                         &outbuf[datalen]);
    ret = 1;
err:
    if (ctx)
        EVP_CIPHER_CTX_cleanup (ctx);
    
    return ret;
}


CsrUint8 csrDecryptCCM (CsrUint8 *data, CsrUint32 datalen,
                        CsrUint8 *key, CsrUint8 len, CsrUint8 *nonce, CsrUint8 nlen,
                        CsrUint8 micsize, CsrUint8 *outbuf)
{
    EVP_CIPHER_CTX *ctx = NULL;
    int outlen;
    int ret = 0;
    
    if ((data == NULL) || (key == NULL) ||
        (nonce == NULL) || (outbuf == NULL))
        goto err;
    printf ("\nKey length :%d",len);
    
    ctx = EVP_CIPHER_CTX_new();
    
    if (ctx == NULL)
        goto err;
    
    EVP_CIPHER_CTX_init (ctx);
    EVP_DecryptInit (ctx, EVP_aes_128_ccm(), 0, 0);
    EVP_CIPHER_CTX_ctrl (ctx, EVP_CTRL_CCM_SET_IVLEN, nlen, 0);
    if (micsize)
        EVP_CIPHER_CTX_ctrl (ctx, EVP_CTRL_CCM_SET_TAG,  micsize, data + datalen);
    EVP_DecryptInit (ctx, 0, key, nonce);
    EVP_DecryptUpdate (ctx, 0, &outlen, 0, datalen);
    EVP_DecryptUpdate (ctx, outbuf, &outlen, data, datalen);
    EVP_DecryptFinal (ctx, &outbuf[outlen], &outlen);
    ret = 1;
err:
    if (ctx)
        EVP_CIPHER_CTX_cleanup (ctx);
    
    return ret;
}

/***********************************************************************
 * csrDecryptData
 * Description: AES-CCM decryption of a pkt
 *		AES key = 128 bit Session key
 *		nonce = SEQ || IV = 104 bits
 *		additional auth data = 0
 * input:
 *  CsrUint8 *					: in buffer (encryptData)
 *  CsrUint16					: data length
 *  CSR_AUTH_SESSION_KEY_T *		: 8 byte session key
 *  CSR_AUTH_IV_T *		: 10 byte IV
 *  CsrUint8 *					: 24bit sequence number
 *  CsrUint8 *					: out buffer
 * return:
 *	1 on Success 0 on Failure
 ***********************************************************************/
CsrUint8 csrDecryptData (CsrUint8 *data, CsrUint16 datalen,
                         CsrUint8 *sessionKey,
                         CsrUint8 *initVector, CsrUint8 *sequence, CsrUint8 *outbuf)
{
    EVP_CIPHER_CTX *ctx = NULL;
    CsrUint8 *nonce = NULL;
    int i, outlen;
    int ret = 0;
    
    if ((data == NULL) || (sessionKey == NULL) || (initVector == NULL) ||
        (sequence == NULL) || (outbuf == NULL))
        goto err;
#ifdef CSR_DEBUG_CRYPTO
    int x;
    fprintf(stdout,"\nlen:\t %d",datalen);
    fprintf (stdout, "\n\n Key:\t");
    for (x = 0; x < CSR_CRYPTO_SESSIONKEY_SIZE; x++)
        fprintf (stdout, "%02x", (unsigned int) * (sessionKey+ x));
#endif
    ctx = EVP_CIPHER_CTX_new();
    
    if (ctx == NULL)
        goto err;
    
    nonce = (CsrUint8 *)OPENSSL_malloc (CSR_CRYPTO_NONCE_SIZE);
    
    if (nonce == NULL)
        goto err;
    
    i = 0;
    memcpy (nonce + i, sequence, CSR_CRYPTO_SEQUENCE_SIZE);
    i += CSR_CRYPTO_SEQUENCE_SIZE;
    memcpy (nonce + i, initVector, CSR_CRYPTO_INIT_VECTOR_SIZE);
    i += CSR_CRYPTO_INIT_VECTOR_SIZE;
#ifdef CSR_DEBUG_CRYPTO
    fprintf (stdout, "\n\n Nonce:\t");
    
    for (x = 0; x < CSR_CRYPTO_NONCE_SIZE; x++)
        fprintf (stdout, "%02x", (unsigned int) * (nonce + x));
    
#endif
    EVP_CIPHER_CTX_init (ctx);
    EVP_DecryptInit (ctx, EVP_aes_128_ccm(), 0, 0);
    EVP_CIPHER_CTX_ctrl (ctx, EVP_CTRL_CCM_SET_IVLEN, CSR_CRYPTO_NONCE_SIZE, 0);
    EVP_CIPHER_CTX_ctrl (ctx, EVP_CTRL_CCM_SET_TAG,  CSR_CRYPTO_MIC_TAG_SIZE,
                         data + datalen);
    EVP_DecryptInit (ctx, 0, sessionKey, nonce);
    EVP_DecryptUpdate (ctx, 0, &outlen, 0, datalen);
    EVP_DecryptUpdate (ctx, outbuf, &outlen, data, datalen);
    EVP_DecryptFinal (ctx, &outbuf[outlen], &outlen);
    ret = 1;
#ifdef CSR_DEBUG_CRYPTO
    fprintf (stdout, "\n\n Crypt Output:\t");
    for (x = 0; x < datalen; x++)
        fprintf (stdout, "%02x", (unsigned int) * (outbuf+ x));
#endif
err:
    
    if (nonce)
        OPENSSL_free (nonce);
    
    if (ctx)
        EVP_CIPHER_CTX_cleanup (ctx);
    
    return ret;
}

/******************************************************************************
 * csrGenerateSBKeyID
 * Description:
 * 	LSOctets[0-3][ SHA256(Encryption Key || IDDiv || GWSBKey)]
 * input:
 * 	CsrUint8 * 			:	4 octets diversifier
 * 	CsrUint8 * 			: 	128 bits GWSBKey
 * return:
 *	1 on Success 0 on Failure
 ******************************************************************************/
CsrUint8 csrGenerateSBKeyID (CsrUint8 *diversifier, CsrUint8 *key,
                             CsrUint8 *sbKeyId)
{
    CsrUint8 ret = 0;
    CsrUint8 con_str[] = "Encryption Key";
    CsrUint8 i, len;
    CsrUint8 *buf = NULL;
    SHA256_CTX ctx;
    CsrUint8 tmpbuf[SHA256_DIGEST_LENGTH]; //32
    
    if ((diversifier == NULL) || (key == NULL) || (sbKeyId == NULL))
        goto err;
    
    len = (sizeof (con_str) - 1)  + CSR_CRYPTO_DIV_SIZE +
    CSR_CRYPTO_SBKEY_SIZE;
    buf = malloc (len);
    
    if (buf == NULL)
        goto err;
    
    i = 0;
    memcpy (buf + i, con_str, sizeof (con_str) - 1);
    i += sizeof (con_str) - 1;
    memcpy (buf + i, diversifier, CSR_CRYPTO_DIV_SIZE);
    i += CSR_CRYPTO_DIV_SIZE;
    memcpy (buf + i, key, CSR_CRYPTO_SBKEY_SIZE);
    i += CSR_CRYPTO_SBKEY_SIZE;
#ifdef CSR_DEBUG_CRYPTO
    int x;
    fprintf (stdout, "\n\n csrGenerateSBKeyID buffer:\t");
    
    for (x = 0; x < len; x++)
        fprintf (stdout, "%02x", (unsigned int) * (buf + x));
    
#endif
    SHA256_Init (&ctx);
    SHA256_Update (&ctx, buf, i);
    SHA256_Final (tmpbuf, &ctx);
    memcpy (sbKeyId, tmpbuf, CSR_CRYPTO_SBKEYID_SIZE);
    ret = 1;
    
#ifdef CSR_DEBUG_CRYPTO
    fprintf (stdout, "\n\n csrGenerateSBKeyID id:\t");
    fprintf (stdout, "%02x%02x%02x%02x", tmpbuf[0], tmpbuf[1],
             tmpbuf[2], tmpbuf[3]);
#endif
err:
    if (buf)
        free (buf);
    
    return ret;
}

/*****************************************************************************
 * csrComputeHMACSHA256
 * Description: Compute HMAC_SHA256
 * 	MAC = LSOctets[outbuflen][ HMAC-SHA256(Key, Text) ]
 * input:
 * 	CsrUint8 * 			:	key
 *	CsrUint16			: 	length of key
 * 	CsrUint8 * 			:	text
 *	CsrUint16			: 	length of text
 * 	CsrUint8 * 			:	output buffer
 *	CsrUint16			: 	length of output buffer
 * return:
 *	1 on Success 0 on Failure
 ********************************************************************************/
CsrUint8 csrComputeHMACSHA256 (const CsrUint8 *key, CsrUint16 keylen, CsrUint8 *text,
                               CsrUint16 textlen, CsrUint8 *outbuf, CsrUint16 outbuflen)
{
    CsrUint8 ret = 0;
    HMAC_CTX ctx;
    CsrUint8 tmpbuf [CSR_CRYPTO_SHA256_HASH_SIZE];
    unsigned int maclen;
    
    if ((key == NULL) || (text == NULL) || (outbuf == NULL))
        goto err;
    
    if ((keylen == 0 ) || (outbuflen == 0) ||
        (outbuflen > CSR_CRYPTO_SHA256_HASH_SIZE))
        goto err;
    
    HMAC_CTX_init (&ctx);
    HMAC_Init_ex (&ctx, key, keylen, EVP_sha256(), NULL);
    HMAC_Update (&ctx, text, textlen);
    HMAC_Final (&ctx, tmpbuf, &maclen);
    
    if (maclen > 0)
        memcpy (outbuf, tmpbuf, outbuflen);
    
    HMAC_CTX_cleanup (&ctx);
    ret = 1;
err:
    return ret;
}

/*****************************************************************************
 * csrComputeSHA256
 * Description: Compute SHA256
 * input:
 * 	CsrUint8 * 			:	text
 *	CsrUint16			: 	length of text
 * 	CsrUint8 * 			:	output buffer
 *	CsrUint16			: 	length of output buffer
 * return:
 *	1 on Success 0 on Failure
 ******************************************************************************/
CsrUint8 csrComputeSHA256 (CsrUint8 *text, CsrUint16 textlen, CsrUint8 *outbuf,
                           CsrUint16 outbuflen)
{
    CsrUint8 ret = 0;
    //	SHA256_CTX ctx;
    CsrUint8 tmpbuf [CSR_CRYPTO_SHA256_HASH_SIZE];
    
    if ((text == NULL) || (outbuf == NULL))
        goto err;
    
    if ((textlen == 0 ) || (outbuflen == 0) ||
        (outbuflen > CSR_CRYPTO_SHA256_HASH_SIZE))
        goto err;
    
    /*
     SHA256_Init (&ctx);
     SHA256_Update (&ctx, text, textlen);
     SHA256_Final (tmpbuf, &ctx);
     */
    SHA256 (text, textlen, tmpbuf);
    memcpy (outbuf, tmpbuf, outbuflen);
    ret = 1;
err:
    return ret;
}

/*****************************************************************************
 * csrEncryptCTR
 * Description: Compute AES-CTR. Assuming a multiple of 16 bytes as input.
 * 	Same method can be used for decryption as well.
 * input:
 * 	CsrUint8 * 			:	16 byte key
 * 	CsrUint8 * 			:	16 byte iv
 * 	CsrUint8 * 			:	input buffer
 * 	CsrUint8 * 			:	output buffer
 * 	CsrUint8  			:	length (multiple of 16)
 * return:
 *	1 on Success 0 on Failure
 ******************************************************************************/
CsrUint8 csrEncryptCTR (CsrUint8 *key, CsrUint8 *iv, CsrUint8 *ibuf,
                        CsrUint8 *obuf, CsrUint8 len)
{
    CsrUint8 counter= 0;
    unsigned int num = 0;
    CsrUint8 sz = AES_BLOCK_SIZE;
    CsrUint8 exitloop = 0;
    CsrUint8 input[AES_BLOCK_SIZE], output[AES_BLOCK_SIZE];
    CsrUint8 ivr[AES_BLOCK_SIZE];
    AES_KEY k;
    CsrUint8 count[AES_BLOCK_SIZE];
    memset (count, 0, AES_BLOCK_SIZE);
    if ((!key) || (!iv) || (!ibuf) || (!obuf))
        goto err;
    
    memcpy (ivr, iv, AES_BLOCK_SIZE);
    AES_set_encrypt_key (key, 128, &k);
    while(1)
    {
        if (sz + counter >= len)
        {
            sz = len - counter;
            exitloop = 1;
        }
        
        memcpy(input, ibuf + counter, sz);
        AES_ctr128_encrypt (input, output, sz,
                            &k, ivr, count, &num);
        memcpy(obuf + counter, output, sz);
        counter += AES_BLOCK_SIZE;
        if (exitloop == 1) break;
    }
    return 1;
err:
    return 0;
}


/*****************************************************************************
 * csrEncryptCBC
 * Description: Compute 128 bit AES-CBC.
 * input:
 * 	CsrUint8 * 			:	16 byte key
 * 	CsrUint8 * 			:	16 byte iv
 * 	CsrUint8 * 			:	input buffer
 * 	CsrUint8 * 			:	output buffer
 * return:
 *	1 on Success 0 on Failure
 ******************************************************************************/
CsrUint8 csrEncryptCBC (const CsrUint8 *key, CsrUint8 *iv,
                        CsrUint8 *ibuf, CsrUint8 *obuf)
{
    CsrUint8 ret = 0;
    int outlen, tlen;
    EVP_CIPHER_CTX ctx;
    CsrUint8* tmp = malloc(AES_BLOCK_SIZE * 2);
    if ((key == NULL) || (iv == NULL) || (ibuf == NULL) || (obuf == NULL))
        goto err;
    
    EVP_CIPHER_CTX_init (&ctx);	
    if (!EVP_EncryptInit_ex (&ctx, EVP_aes_128_cbc(), NULL, key, iv))
        goto err;
    if(!EVP_EncryptInit_ex(&ctx, NULL, NULL, NULL, NULL))
        goto err;
    if (!EVP_EncryptUpdate (&ctx, tmp, &outlen, (unsigned char*) ibuf, 16))
        goto err;
    if (!EVP_EncryptFinal_ex (&ctx, tmp + outlen, &tlen))
        goto err;
    
    outlen += tlen;
    EVP_CIPHER_CTX_cleanup (&ctx);
    memcpy(obuf, tmp, AES_BLOCK_SIZE);
    ret = 1;
err:
    if (tmp)
        free(tmp);
    return ret;
}

/*****************************************************************************
 * csrDecryptCBC
 * Description: Compute 128 bit AES-CBC.
 * input:
 * 	CsrUint8 * 			:	16 byte key
 * 	CsrUint8 * 			:	16 byte iv
 * 	CsrUint8 * 			:	input buffer
 * 	CsrUint8 * 			:	output buffer
 * return:
 *	1 on Success 0 on Failure
 ******************************************************************************/
CsrUint8 csrDecryptCBC (const CsrUint8 *key, CsrUint8 *iv,
                        CsrUint8 *ibuf, CsrUint8 *obuf)
{
    CsrUint8 ret = 0;
    int outlen, tlen;
    EVP_CIPHER_CTX ctx;
    CsrUint8* tmp = malloc(16+16);
    if ((key == NULL) || (iv == NULL) || (ibuf == NULL) || (obuf == NULL))
        goto err;
    
    EVP_CIPHER_CTX_init (&ctx);	
    if (!EVP_DecryptInit_ex (&ctx, EVP_aes_128_cbc(), NULL, key, iv))
        goto err;
    
    
    if (!EVP_DecryptUpdate (&ctx, tmp, &outlen, (unsigned char*) ibuf, 16))
        goto err;
    if (!EVP_DecryptFinal_ex (&ctx, tmp + outlen, &tlen))
        goto err;
    
    outlen += tlen;
    EVP_CIPHER_CTX_cleanup (&ctx);
    memcpy(obuf, tmp, 16);
    ret = 1;
err:
    if (tmp)
        free(tmp);
    return ret;
}
