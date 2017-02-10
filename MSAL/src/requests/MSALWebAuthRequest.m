//------------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//------------------------------------------------------------------------------


#import "MSALWebAuthRequest.h"
#import "MSALWebAuthResponse.h"

@implementation MSALWebAuthRequest

- (id)initWithURL:(NSURL *)endpoint session:(NSURLSession *)session
          context:(id<MSALRequestContext>)context
{
    self = [super initWithURL:endpoint session:session context:context];
    if (!self)
    {
        return nil;
    }
    
#if PKEYAUTH_IMPLEMENTED
    [self.headers setValue:MSALPKeyAuthHeaderVersion forKey:MSALPKeyAuthHeader];
#endif
    
    [self setAcceptJSON];
    [self setContentTypeFormURLEncoded];
    
    _retryIfServerError = YES;
    
    return self;
}


- (void)sendGet:(MSALHttpRequestCallback)completionHandler
{
    [super sendGet:^(NSError  *error, MSALHttpResponse *response)
    {
        if (error)
        {
            completionHandler(error, response);
        }
        else
        {
            [MSALWebAuthResponse processResponse:response
                                         request:self
                                         context:self.context
                               completionHandler:completionHandler];
        }
    }];
}

- (void)sendPost:(MSALHttpRequestCallback)completionHandler
{
    [super sendPost:^(NSError  *error, MSALHttpResponse *response)
    {
        if (error)
        {
            completionHandler(error, response);
        }
        else
        {
            [MSALWebAuthResponse processResponse:response
                                         request:self
                                         context:self.context
                               completionHandler:completionHandler];
        }
    }];
}
@end
