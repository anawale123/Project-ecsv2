import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 200 },
    { duration: '1m', target: 300 },
    { duration: '1m', target: 400 },
    { duration: '1m', target: 500 },
    { duration: '1m', target: 600 },
    { duration: '1m', target: 700 },
    { duration: '1m', target: 800 },
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],
    http_req_failed:   ['rate<0.01'],
  },
};

export default function () {
  const payload = JSON.stringify({ url: 'https://example.com' });
  const params = { headers: { 'Content-Type': 'application/json' } };

  const shorten = http.post('https://url-shortener-aws.co.uk/shorten', payload, params);
  
  if (shorten.status !== 200) {
    console.log(`Error at VU=${__VU} stage VUs=${__ITER} status=${shorten.status} body=${shorten.body.substring(0, 100)}`);
  }

  check(shorten, {
    'shorten status 200': (r) => r.status === 200,
    'shorten has short': (r) => {
      try {
        return JSON.parse(r.body).short !== undefined;
      } catch (e) {
        console.log(`JSON parse error at VU=${__VU}: ${r.body.substring(0, 100)}`);
        return false;
      }
    },
  });

  sleep(1);

  if (shorten.status === 200) {
    const code = JSON.parse(shorten.body).short;
    const stats = http.get(`https://url-shortener-aws.co.uk/stats/${code}`);
    check(stats, {
      'stats status 200': (r) => r.status === 200,
    });
  }

  sleep(1);
}
