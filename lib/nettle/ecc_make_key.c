/* LibTomCrypt, modular cryptographic library -- Tom St Denis
 *
 * LibTomCrypt is a library that provides various cryptographic
 * algorithms in a highly modular and flexible manner.
 *
 * The library is free for all purposes without any express
 * guarantee it works.
 *
 * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
 */

/* Implements ECC over Z/pZ for curve y^2 = x^3 + ax + b
 *
 * All curves taken from NIST recommendation paper of July 1999
 * Available at http://csrc.nist.gov/cryptval/dss.htm
 */
#include "ecc.h"

/**
  @file ecc_make_key.c
  ECC Crypto, Tom St Denis
*/

/**
  Make a new ECC key 
  @param prng         An active PRNG state
  @param wprng        The index of the PRNG you wish to use
  @param prime        The prime of curve's field
  @param order        The order of the G point
  @param A            The "a" parameter of the curve
  @param Gx           The x coordinate of the base point
  @param Gy           The y coordinate of the base point
  @return 0 if successful, upon error all allocated memory will be freed
*/

int
ecc_make_key_ex (void *random_ctx, nettle_random_func random, ecc_key * key,
                 mpz_t prime, mpz_t order, mpz_t A, mpz_t Gx, mpz_t Gy)
{
  int err;
  ecc_point *base;
  unsigned char *buf;
  int keysize;

  assert (key != NULL);
  assert (random != NULL);

  keysize = nettle_mpz_sizeinbase_256_u (order);

  /* allocate ram */
  base = NULL;
  buf = malloc (keysize);
  if (buf == NULL)
    {
      return -1;
    }

  /* make up random string */
  random (random_ctx, keysize, buf);

  /* setup the key variables */
  if ((err =
       mp_init_multi (&key->pubkey.x, &key->pubkey.y, &key->pubkey.z, &key->k,
                      &key->prime, &key->order, &key->A, &key->Gx, &key->Gy,
                      NULL)) != 0)
    {
      goto ERR_BUF;
    }
  base = ecc_new_point ();
  if (base == NULL)
    {
      err = -1;
      goto errkey;
    }

  /* read in the specs for this key */
  mpz_set (key->prime, prime);
  mpz_set (key->order, order);
  mpz_set (key->Gx, Gx);
  mpz_set (key->Gy, Gy);
  mpz_set (key->A, A);

  mpz_set (base->x, key->Gx);
  mpz_set (base->y, key->Gy);
  mpz_set_ui (base->z, 1);
  
  nettle_mpz_set_str_256_u (key->k, keysize, buf);

  /* the key should be smaller than the order of base point */
  if (mpz_cmp (key->k, key->order) >= 0)
    {
      mpz_mod (key->k, key->k, key->order);
    }
  /* make the public key */
  if ((err =
       ecc_mulmod (key->k, base, &key->pubkey, key->A, key->prime,
                       1)) != 0)
    {
      goto errkey;
    }
  key->type = PK_PRIVATE;

  /* free up ram */
  err = 0;
  goto cleanup;
errkey:
  mp_clear_multi (&key->pubkey.x, &key->pubkey.y, &key->pubkey.z, &key->k,
                  &key->order, &key->prime, &key->Gx, &key->Gy, &key->A,
                  NULL);
cleanup:
  ecc_del_point (base);
ERR_BUF:
  free (buf);
  return err;
}

int
ecc_make_key (void *random_ctx, nettle_random_func random, ecc_key * key,
              const ecc_set_type * dp)
{
  mpz_t prime, order, Gx, Gy, A;
  int err;

  /* setup the key variables */
  if ((err = mp_init_multi (&prime, &order, &A, &Gx, &Gy, NULL)) != 0)
    {
      goto cleanup;
    }

  /* read in the specs for this key */
  mpz_set_str (prime, (char *) dp->prime, 16);
  mpz_set_str (order, (char *) dp->order, 16);
  mpz_set_str (Gx, (char *) dp->Gx, 16);
  mpz_set_str (Gy, (char *) dp->Gy, 16);
  mpz_set_str (A, (char *) dp->A, 16);

  err = ecc_make_key_ex (random_ctx, random, key, prime, order, A, Gx, Gy);

  mp_clear_multi (&prime, &order, &A, &Gx, &Gy, NULL);
cleanup:
  return err;
}

/* $Source: /cvs/libtom/libtomcrypt/src/pk/ecc/ecc_make_key.c,v $ */
/* $Revision: 1.13 $ */
/* $Date: 2007/05/12 14:32:35 $ */