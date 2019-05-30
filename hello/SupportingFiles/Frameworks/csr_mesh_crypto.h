#ifndef __CSR_MESH_CRYPTO__
#define __CSR_MESH_CRYPTO__
/*****************************************************************************
 *  Copyright 2016 Qualcomm Technologies International, Ltd.
 *****************************************************************************/
/*! \file csr_mesh_crypto.h
 *  \brief header for csr cryptographic library.
 *
 *   This file exposes operations for ECDH and AES-CCM implemented by OpenSSL
 */
/*****************************************************************************/
//#include "csr_types.h"
#ifdef __cplusplus
extern "C" {
#endif
    //definitions
#define CSR_CRYPTO_DIVERSIFIER_SIZE 8
#define CSR_CRYPTO_SECRET_SIZE 24
#define CSR_CRYPTO_SESSIONKEY_SIZE 16
#define CSR_CRYPTO_RAND_SIZE 16
#define CSR_CRYPTO_APPKEY_SIZE 32
#define CSR_CRYPTO_SHA256_HASH_SIZE 32
#define CSR_CRYPTO_APPID_HASH_SIZE 8
#define CSR_CRYPTO_PRIVATE_KEY_SIZE 24
#define CSR_CRYPTO_PUBLIC_KEY_SIZE 24
#define CSR_CRYPTO_CHALLENGE_SIZE 8
#define CSR_CRYPTO_SEQUENCE_SIZE 3
#define CSR_CRYPTO_INIT_VECTOR_SIZE 10
#define CSR_CRYPTO_MIC_SIZE 4
#define CSR_CRYPTO_DIV_SIZE 4
#define CSR_CRYPTO_SBKEY_SIZE 16
#define CSR_CRYPTO_SBKEYID_SIZE 4
    //structures
    
#define CsrUint8 unsigned char
#define CsrUint16 uint16_t
#define CsrUint32 uint32_t
    
    
    typedef struct
    {
        CsrUint8 pubKeyX [24];
        CsrUint8 pubKeyY [24];
    } CSR_AUTH_PUB_KEY_T;
    
    typedef struct
    {
        CsrUint8 privatekey[24];
        CSR_AUTH_PUB_KEY_T publickey;
    } CSR_AUTH_EPH_KEY_T;
    
    //API
    CsrUint8 csrCreateEphemeralKeypair (CSR_AUTH_EPH_KEY_T *k);
    
    CsrUint8 csrGenerateSecret (const CsrUint8 *prk,
                                const CSR_AUTH_PUB_KEY_T *pub,
                                CsrUint8 *secret);
    
    CsrUint8 csrGenerateChallenge (CsrUint8 *appkey,
                                   CsrUint8 *secret, CSR_AUTH_PUB_KEY_T *a,
                                   CSR_AUTH_PUB_KEY_T *b, CsrUint8 *random_num, CsrUint8 *challenge1);
    
    CsrUint8 csrGenerateSessionKey (CsrUint8 *secret,
                                    CsrUint8 *diversifier, CsrUint8 *outbuf);
    
    CsrUint8 csrGenerateRandom (CsrUint8 *buf, CsrUint16 len);
    
    CsrUint8 csrEncryptData (CsrUint8 *data, CsrUint16 datalen,
                             CsrUint8 *sessionKey,
                             CsrUint8 *initVector, CsrUint8 *sequence, CsrUint8 *outbuf);
    
    CsrUint8 csrDecryptData (CsrUint8 *data, CsrUint16 datalen,
                             CsrUint8 *sessionKey,
                             CsrUint8 *initVector, CsrUint8 *sequence, CsrUint8 *outbuf);
    
    CsrUint8 csrGenerateSBKeyID (CsrUint8 *diversifier, CsrUint8 *key,
                                 CsrUint8 *sbKeyId);
    CsrUint8 csrComputeHMACSHA256 (const CsrUint8 *key, CsrUint16 keylen, CsrUint8 *text,
                                   CsrUint16 textlen, CsrUint8 *outbuf, CsrUint16 outbuflen);
    CsrUint8 csrEncryptCBC (const CsrUint8 *key, CsrUint8 *iv,
                            CsrUint8 *ibuf, CsrUint8 *obuf);
    CsrUint8 csrDecryptCBC (const CsrUint8 *key, CsrUint8 *iv,
                            CsrUint8 *ibuf, CsrUint8 *obuf);
    CsrUint8 csrEncryptCTR (CsrUint8 *key, CsrUint8 *iv, CsrUint8 *ibuf,
                            CsrUint8 *obuf, CsrUint8 len);
    CsrUint8 csrComputeSHA256 (CsrUint8 *text, CsrUint16 textlen,
                               CsrUint8 *outbuf, CsrUint16 outbuflen);
    CsrUint8 csrDecryptCCM (CsrUint8 *data, CsrUint32 datalen,
                            CsrUint8 *key, CsrUint8 len,
                            CsrUint8 *nonce, CsrUint8 nlen,
                            CsrUint8 micsize, CsrUint8 *outbuf);
    CsrUint8 csrEncryptCCM (CsrUint8 *data, CsrUint32 datalen,
                            CsrUint8 *key, CsrUint8 len,
                            CsrUint8 *nonce, CsrUint8 nlen,
                            CsrUint8 micsize, CsrUint8 *outbuf);
#ifdef __cplusplus
}
#endif
#endif
