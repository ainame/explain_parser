require 'spec_helper'

describe ExplainParser do
  context 'given explain string' do
    let(:input) do
      <<-EOS
+----+-------------+-------+------+---------------+------+---------+------+------+-------+
| id | select_type | table | type | possible_keys | key  | key_len | ref  | rows | Extra |
+----+-------------+-------+------+---------------+------+---------+------+------+-------+
|  1 | SIMPLE      | users | ALL  | NULL          | NULL | NULL    | NULL |  155 | NULL  |
+----+-------------+-------+------+---------------+------+---------+------+------+-------+
1 row in set (0.00 sec)
    EOS
    end
    subject { ExplainParser.new(input) }

    describe '.new' do
      it { is_expected.to be_kind_of(ExplainParser)}
    end

    describe '#call' do
      it 'should ExplainParser::Explain' do
        expect(subject.call).to be_kind_of(Array)
        expect(subject.call[0]).to be_kind_of(ExplainParser::Explain)
      end

      it 'should ExplainParser::Explain' do
        explain = subject.call[0]
        expect(explain.id).to eq 1
        expect(explain.select_type).to eq 'SIMPLE'
        expect(explain.table).to eq 'users'
        expect(explain.type).to eq 'ALL'
        expect(explain.possible_keys).to eq nil
        expect(explain.key).to eq nil
        expect(explain.key_len).to eq nil
        expect(explain.ref).to eq nil
        expect(explain.rows).to eq 155
        expect(explain.extra).to eq nil
        expect(explain.using_filesort?).to be false
        expect(explain.using_where?).to be false
        expect(explain.using_temporary?).to be false
        expect(explain.using_index?).to be false
      end
    end
  end

  context 'given explain string with extra' do
    let(:input) do
      <<-EOS
+----+-------------+-------+--------+----------------------------------------------------------+
| id | select_type | table | type   | Extra                                                    |
+----+-------------+-------+--------+----------------------------------------------------------+
|  1 | SIMPLE      | tc    | ref    | Using where; Using index Using temporary; Using filesort |
+----+-------------+-------+--------+----------------------------------------------------------+
1 row in set (0.00 sec)
    EOS
    end
    subject { ExplainParser.new(input) }

    describe '#call' do
      it 'should ExplainParser::Explain' do
        explain = subject.call[0]
        expect(explain.extra).to be_truthy
        expect(explain.using_filesort?).to be true
        expect(explain.using_where?).to be true
        expect(explain.using_temporary?).to be true
        expect(explain.using_index?).to be true
      end
    end
  end

  context 'given explain string with multi line' do
    let(:input) do
      <<-EOS
+----+-------------+-------+--------+----------------------------------------------------------+
| id | select_type | table | type   | Extra                                                    |
+----+-------------+-------+--------+----------------------------------------------------------+
|  1 | SIMPLE      | tc    | ref    | Using where; Using index Using temporary; Using filesort |
|  2 | SIMPLE      | tc    | ref    | Using where; Using index Using temporary; Using filesort |
|  3 | SIMPLE      | tc    | ref    | NULL                                                     |
+----+-------------+-------+--------+----------------------------------------------------------+
2 row in set (0.00 sec)
    EOS
    end
    subject { ExplainParser.new(input) }

    describe '#call' do
      it 'should ExplainParser::Explain' do
        explains = subject.call
        expect(explains.size).to be 3
      end
    end
  end

  context 'given explain string with multi line' do
    let(:input) do
      <<-EOS
+----+-------------+-------+--------+----------------------------------------------------------+
| id | select_type | table | type   | Extra                                                    |
+----+-------------+-------+--------+----------------------------------------------------------+
|  1 | SIMPLE      | tc    | ref    | Using where; Using index Using temporary; Using filesort |
|  2 | SIMPLE      | tc    | ref    | Using where; Using index Using temporary; Using filesort |
|  3 | SIMPLE      | tc    | ref    | NULL                                                     |
+----+-------------+-------+--------+----------------------------------------------------------+
2 row in set (0.00 sec)
    EOS
    end

    describe '.call' do
      it 'should ExplainParser::Explain' do
        explains = ExplainParser.call(input)
        expect(explains.size).to be 3
      end
    end
  end
end
